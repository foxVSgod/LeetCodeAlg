//
//  EMPlayDownloader.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/24.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMDownloaderoperation.h"

@interface EMPlayDownloadToken : NSObject
@property (nonatomic, strong, nullable) NSURL *url;
@property (nonatomic, strong, nullable) id downloadOperationCancelToken;
@end

@interface EMPlayDownloader : NSObject
@property (assign, nonatomic) NSInteger maxConcurrentDownloads;
@property (readonly, nonatomic) NSUInteger currentDownloadCount;
@property (assign, nonatomic) NSTimeInterval downloadTimeout;
/**
 *  Set the default URL credential to be set for request operations.
 */
@property (strong, nonatomic, nullable) NSURLCredential *urlCredential;
- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration NS_DESIGNATED_INITIALIZER;

- (nullable EMPlayDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                               options:(EMAudioDownloaderOperations)options
                                         CompletedBlock:(nullable EMAudioDownloaderCompletedBlock)completedBlcok
                                               Analyze:(nullable EMAudioAnalysisCompletedBlock)analysisBlock;
- (void)cancel:(nullable EMPlayDownloadToken *)token;

/**
 * Sets the download queue suspension state
 */
- (void)setSuspended:(BOOL)suspended;

/**
 * Cancels all download operations in the queue
 */
- (void)cancelAllDownloads;

+ (nonnull instancetype)sharedDownloader;
@end
