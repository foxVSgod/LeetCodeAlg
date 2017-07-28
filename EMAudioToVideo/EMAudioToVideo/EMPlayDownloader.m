//
//  EMPlayDownloader.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/24.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMPlayDownloader.h"

@implementation EMPlayDownloadToken

@end

@interface EMPlayDownloader()<NSURLSessionDelegate>{

}
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, strong) NSOperation *lastAddedOperation;
@property (nonatomic, strong) Class operetionClass;
@property (nonatomic, strong) NSMutableDictionary <NSURL *, EMDownloaderoperation *> *urlOperations;
@property (nonatomic, strong) dispatch_queue_t barrierQueue;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation EMPlayDownloader

- (nonnull instancetype)init {
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration{
    if (self = [super init]) {
        _operetionClass  = [EMDownloaderoperation class];
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 2;
        _downloadQueue.name = @"com.emcompany.EMstockInfoDownloader";
        _urlOperations = [NSMutableDictionary new];
        _barrierQueue = dispatch_queue_create("com.emcompany.EMstockInfoDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
        sessionConfiguration.timeoutIntervalForRequest = _downloadTimeout;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    return self;
}

- (NSString *)cacheRouthpath{
    return  @"";
}

- (void)dealloc{
    [self.session invalidateAndCancel];
    self.session = nil;
    [self.downloadQueue cancelAllOperations];
}

+ (instancetype)sharedDownloader {
    static EMPlayDownloader *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads{
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount{
    return  _downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads{
    return  _downloadQueue.maxConcurrentOperationCount;
}

- (EMPlayDownloadToken *)downloadImageWithURL:(NSURL *)url stockInfo:(NSString *)stockCode options:(EMAudioDownloaderOperations)options ProgressBlock:(EMAudioDownloaderProgressBlock)progressBlcok CompletedBlock:(EMAudioDownloaderCompletedBlock)completedBlcok Analyze:(EMAudioAnalysisCompletedBlock)analysisBlock{
    __weak EMPlayDownloader *weakself = self;

    return [self addProgressBlock:progressBlcok completedBlock:completedBlcok Analyze:analysisBlock forURL:url createCallback:^EMDownloaderoperation *{
        __strong __typeof (weakself) strongself = weakself;
        NSTimeInterval timeoutInterval = strongself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }
        NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringCacheData;
        if (options & EMAudioDownloaderUseNSURLCache) {
            if (options & EMAudioDownloaderIgnoreCachedResponse) {
                cachePolicy = NSURLRequestReturnCacheDataDontLoad;
            } else {
                cachePolicy = NSURLRequestUseProtocolCachePolicy;
            }
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
        request.HTTPShouldUsePipelining = YES;

        EMDownloaderoperation *operation = [[strongself.operetionClass alloc] initWithRequest:request stockInfor:stockCode UrlSession:strongself.session downloaderoptions:options];
        if (options&EMAudioDownloaderHighPriority) {
            operation.queuePriority = NSOperationQueuePriorityHigh;
        }else{
            operation.queuePriority = NSOperationQueuePriorityLow;
        }

        [strongself.downloadQueue addOperation:operation];
        return operation;
    }];
}

- (void)cancel:(EMPlayDownloadToken *)token{
    dispatch_barrier_async(self.barrierQueue, ^{
        EMDownloaderoperation *operation = self.urlOperations[token.url];
        BOOL canceled = [operation cancle:token.downloadOperationCancelToken];
        if (canceled) {
            [self.urlOperations removeObjectForKey:token.url];
        }
    });
}

- (EMDownloaderoperation *)operationWithTask:(NSURLSessionTask *)tasksesssion{
    EMDownloaderoperation *retunOperation = nil;
    for (EMDownloaderoperation *operation in self.downloadQueue.operations) {
        if (operation.downTask.taskIdentifier == tasksesssion.taskIdentifier) {
            retunOperation = operation;
            break;
        }
    }
    return  retunOperation;
}

- (void)cancelAllDownloads{
    [self.downloadQueue cancelAllOperations];
}

- (nullable EMPlayDownloadToken *)addProgressBlock:(EMAudioDownloaderProgressBlock)progressBlcok completedBlock:(EMAudioDownloaderCompletedBlock)completedBlock
                                           Analyze:(EMAudioAnalysisCompletedBlock)analysisBlock
                                                   forURL:(nullable NSURL *)url
                                           createCallback:(EMDownloaderoperation *(^)())createCallback {
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, NO);
        }
        return nil;
    }

    __block EMPlayDownloadToken *token = nil;

    dispatch_barrier_sync(self.barrierQueue, ^{
        EMDownloaderoperation *operation = self.urlOperations[url];
        if (!operation) {
            operation = createCallback();
            self.urlOperations[url] = operation;
            __weak EMDownloaderoperation *woperation = operation;
            operation.completionBlock = ^{
                EMDownloaderoperation *soperation = woperation;
                if (!soperation) return;
                if (self.urlOperations[url] == soperation) {
                    [self.urlOperations removeObjectForKey:url];
                };
            };
        }
        id downloadOperationCancelToken = [operation addProgressBlock: progressBlcok handlesCompletedBlock:completedBlock Analyze:analysisBlock];
        token = [EMPlayDownloadToken new];
        token.url = url;
        token.downloadOperationCancelToken = downloadOperationCancelToken;
    });
    
    return token;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    EMDownloaderoperation *downOperation = [self operationWithTask:downloadTask];
    [downOperation URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    EMDownloaderoperation *downOperation = [self operationWithTask:downloadTask];
    [downOperation URLSession:session downloadTask:downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;{
    //    self.progerss = totalBytesWritten / totalBytesExpectedToWrite;
    EMDownloaderoperation *downOperation = [self operationWithTask:downloadTask];
    [downOperation URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}
@end
