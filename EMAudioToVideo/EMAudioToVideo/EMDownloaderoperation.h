//
//  EMDownloaderoperation.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/24.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

@import UIKit;
@import Foundation;
#import "EMPlayResponse.h"

typedef NS_OPTIONS(NSUInteger, EMAudioDownloaderOperations){
    EMAudioDownloaderProgressDowmload = 1 <<0,
    EMAudioDownloaderUseNSURLCache    = 1 <<1,
    EMAudioDownloaderIgnoreCachedResponse = 1 <<2,
    EMAudioDownloaderContinueInBackground = 1 <<3,
    EMAudioDownloaderHighPriority = 1 <<4
};
typedef void(^EMAudioDownloaderCompletedBlock)( NSString * _Nullable filePath, NSError * _Nullable error, BOOL finished);

@interface EMDownloaderoperation : NSOperation<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong, nullable) NSURLRequest *request;
@property (nonatomic, strong, readonly,nullable) NSURLSessionDownloadTask *downTask;
@property (nonatomic, strong, nullable) NSURLResponse *response;
@property (nonatomic, strong, nullable) NSString *localfilePath;
@property (nonatomic, assign, readonly) EMAudioDownloaderOperations options;
- (nonnull instancetype ) initWithRequest:(NSURLRequest *_Nullable)reqest UrlSession:(NSURLSession *_Nullable)sesstion downloaderoptions:(EMAudioDownloaderOperations)operations NS_DESIGNATED_INITIALIZER;

- (nonnull id)addhandlesCompletedBlock:(nullable EMAudioDownloaderCompletedBlock)completedBlcok Analyze:(nullable EMAudioAnalysisCompletedBlock)analysisBlock;

- (BOOL)cancle:(nonnull id)token;
//- (void)startdownData;
//- (void)continueAction;
//- (void)pauseDownload;
@end
