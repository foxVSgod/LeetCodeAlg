//
//  EMDownloaderoperation.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/24.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMDownloaderoperation.h"
#import <objc/NSObject.h>
typedef NSMutableDictionary<NSString *, id> EMDownerReCallDictionay;
static NSString *const kAnalysisCallbackKey = @"AnalysisCompleted";
static NSString *const kCompletedCallbackKey = @"completed";
static NSString *const kProgressCallbackKey = @"progress";

@interface EMDownloaderoperation(){
}
// This is weak because it is injected by whoever manages this session. If this gets nil-ed out, we won't be able to run
// the task associated with this operation
@property (weak, nonatomic, nullable) NSURLSession *unownedSession;
// This is set if we're using not using an injected NSURLSession. We're responsible of invalidating this one
@property (strong, nonatomic, nullable) NSURLSession *ownedSession;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, strong) NSData *downloaddata;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) id  downdataCache;
@property (nonatomic, strong ,readwrite, nullable) NSURLSessionDownloadTask *downTask;
@property (nonatomic ,strong) dispatch_queue_t barrierQueue;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
@property (strong, nonatomic, nonnull) NSMutableArray<EMDownerReCallDictionay *> *callbackBlocks;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong, nullable) NSString *localfilePath;
@property (nonatomic, strong) EMPlayResponse *analysisobjct;
@property (nonatomic, strong) NSString *stockcodevalue;
@end

@implementation EMDownloaderoperation{

}

@synthesize executing = _executing;
@synthesize finished = _finished;

static void  *barrierQueueStr = "barrierindenty";
- (instancetype)init{
    return  [self initWithRequest:nil stockInfor:nil UrlSession:nil downloaderoptions:0];
}


- (instancetype)initWithRequest:(NSURLRequest *)reqest stockInfor:(NSString *)stockCode UrlSession:(NSURLSession *)sesstion downloaderoptions:(EMAudioDownloaderOperations)operations{
    self = [super init];
    if (self) {
        _request = [reqest copy];
        self.stockcodevalue = stockCode;
        _options = operations;
        _executing = NO;
        _finished = NO;
        _unownedSession = sesstion;
        _callbackBlocks = [NSMutableArray new];
        _barrierQueue = dispatch_queue_create("com.EMCompany.EMStockInfoDownloaderOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(_barrierQueue, barrierQueueStr, &barrierQueueStr , NULL);
    }
    return self;
}

- (void)dealloc{
    //SDDispatchQueueRelease(_barrierQueue);
}

- (id)addProgressBlock:(EMAudioDownloaderProgressBlock )progressBlcok handlesCompletedBlock:(EMAudioDownloaderCompletedBlock)completedBlcok Analyze:(EMAudioAnalysisCompletedBlock)analysisBlock{
    EMDownerReCallDictionay *reCallbacks = [NSMutableDictionary new];
    if (progressBlcok) {
        reCallbacks[kProgressCallbackKey] = progressBlcok;
    }
    if (completedBlcok) {
        reCallbacks[kCompletedCallbackKey] = [completedBlcok copy];
    }
    if (analysisBlock) {
        reCallbacks[kAnalysisCallbackKey] = [analysisBlock copy];
    }
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callbackBlocks  addObject:reCallbacks];
    });
    return  reCallbacks;
}

- (NSArray<id> *)callbackForKey:(NSString *)key{
    __block NSMutableArray *callBacks = nil;
    if (dispatch_get_specific(barrierQueueStr)) {
        callBacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
        [callBacks removeObjectIdenticalTo:[NSNull null]];
    }else{
        dispatch_sync(self.barrierQueue, ^{
            callBacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
            [callBacks removeObjectIdenticalTo:[NSNull null]];
        });
    }
    return [callBacks copy];
}

- (BOOL)cancle:(id)token{
    __block BOOL shouldCancel = NO;
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callbackBlocks removeObjectIdenticalTo:token];
        if (self.callbackBlocks.count == 0) {
            shouldCancel = YES;
        }
    });
    if (shouldCancel) {
        [self cancel];
    }
    return  shouldCancel;
}

- (void)cancel{
    @synchronized (self) {
        [self cancelInternal];
    }
}

- (void)cancelInternal {
    if (self.isFinished) return;
    [super cancel];

    if (self.downTask) {
        [self.downTask cancel];
        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }

    [self reset];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

-(BOOL)isAsynchronous{
    return YES;
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
    });
    self.downTask = nil;
    self.downloaddata = nil;
    if (self.ownedSession) {
        [self.ownedSession invalidateAndCancel];
        self.ownedSession = nil;
    }
}

- (void)start{
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        NSURLSession *session = self.unownedSession;
        if(!self.unownedSession){
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest  = 15;
            self.ownedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            session = self.ownedSession;
        }
        self.downTask = [session downloadTaskWithURL:_request.URL];
        self.executing = YES;
//        __weak typeof(self) weakself = self;
//        [self.downTask  cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//            if (weakself) {
//                weakself.resumeData = [NSData dataWithData:resumeData];
//                [weakself cancel];
//            }
//        }];
    }
    [self.downTask resume];

    if (self.downTask) {

    } else {
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Connection can't be initialized"}]];
    }

    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId !=UIBackgroundTaskInvalid) {
        UIApplication *app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }

    if (self.downTask) {
        for (EMAudioDownloaderProgressBlock progressBlock in [self callbackForKey:kProgressCallbackKey]) {
            progressBlock(0, NSURLResponseUnknownLength, self.request.URL);
        }
    }

    
}

#pragma mark NSURLSessionDownloadDelegate

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    return;
}

- (void)setOperationFinished{
    [self.session invalidateAndCancel];
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

+ (NSString *)resourceZipRouthPath{
    NSString *localbashPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageBaseUrl = [localbashPath stringByAppendingString:@"StockResource/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageBaseUrl]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[localbashPath stringByAppendingString:@"StockResource"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageBaseUrl;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *localbashPath = [EMDownloaderoperation resourceZipRouthPath];
    NSString *filePath = [localbashPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",self.stockcodevalue]];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager moveItemAtURL:location toURL:fileURL error:nil];
    self.localfilePath = filePath;
    if (isSuccess){
        NSLog(@"数据下载完成");
    }
    [self callCompletionBlocksWithfilePath:self.localfilePath error:nil finished:YES];
    self.analysisobjct = [[EMPlayResponse alloc] initWithResponseFilepath:[NSURL URLWithString:self.localfilePath] stockInfro:self.stockcodevalue];
    __weak typeof(self) weakself = self;
    [self.analysisobjct setAnalysisCompleteBlock:  ^(NSString * _Nullable audioFilepath, NSArray * _Nullable imagepathArray, NSDictionary *_Nullable timeDict, NSError * _Nullable error, BOOL finished) {
        if (weakself) {
            NSArray<id> *completionBlocks = [weakself callbackForKey:kAnalysisCallbackKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (EMAudioAnalysisCompletedBlock completedBlock in completionBlocks) {
                    completedBlock(audioFilepath,imagepathArray,timeDict,error,finished);
                }
            });
        }
        weakself.finished = YES;
    }];
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.analysisobjct AnalyzeAlldata];
    });
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 8.0) {
        self.downTask = [session downloadTaskWithResumeData:self.resumeData];
        [self.downTask resume];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    for (EMAudioDownloaderProgressBlock progressBlock in [self callbackForKey:kProgressCallbackKey]) {
        progressBlock(totalBytesWritten, totalBytesExpectedToWrite, self.request.URL);
    }
}

- (BOOL)shouldContinueWhenAppEntersBackground {
    return self.options & EMAudioDownloaderContinueInBackground;
}

- (void)callCompletionBlocksWithError:(nullable NSError *)error {
    [self callCompletionBlocksWithfilePath:nil error:error finished:YES];
}

- (void)callCompletionBlocksWithfilePath:(nullable NSString *)filepath error:(nullable NSError *)error finished:(BOOL)finished{
    NSArray<id> *completionBlocks = [self callbackForKey:kCompletedCallbackKey];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (EMAudioDownloaderCompletedBlock completedBlock in completionBlocks) {
            completedBlock(self.localfilePath,error, finished);
        }
    });
}
@end

