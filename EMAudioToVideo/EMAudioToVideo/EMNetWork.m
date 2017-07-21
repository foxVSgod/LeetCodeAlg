//
//  EMNetWork.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/19.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMNetWork.h"

@interface EMDownloadloader()<NSURLSessionDownloadDelegate>{
    NSUUID *receoptID;
}
@property (nonatomic, strong) NSURLSessionDownloadTask *downTask;
@property (nonatomic, assign) double progerss;
@property (nonatomic, strong) NSData *downloaddata;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation EMDownloadloader


- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)sharedManager {
    static EMDownloadloader *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)startdownData{
    if (self.urlpath) {
        return;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURL *downUrl = [NSURL URLWithString:self.urlpath];

    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:downUrl];
    self.downTask = [self.session downloadTaskWithRequest:request];
    [self.downTask resume];
}

- (void)pauseDownload{
    [self.downTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.downloaddata = resumeData;
    }];
    self.downTask = nil;
}

- (void)continueAction{
    self.downTask = [self.session downloadTaskWithResumeData:self.downloaddata];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents.music.mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager moveItemAtURL:location toURL:fileURL error:nil];
    if (isSuccess) {
        NSLog(@"数据下载完成");
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents.music.mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager moveItemAtURL: [NSURL URLWithString:self.localfilePath] toURL:fileURL error:nil];
    if (isSuccess) {
        NSLog(@"数据下载完成");
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;{
    self.progerss = totalBytesWritten / totalBytesExpectedToWrite;
}
@end
