//
//  EMNetWork.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/19.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMDownloadloader : NSObject
@property (nonatomic, strong, nullable) id  downdataCache;
@property (nonatomic, strong, nullable) NSURL *baseUrl;
@property (nonatomic, strong, nullable) NSString *localfilePath;
- (void)startdownData;
- (void)continueAction;
- (void)pauseDownload;
+ (instancetype _Nullable )sharedManager;

@end

