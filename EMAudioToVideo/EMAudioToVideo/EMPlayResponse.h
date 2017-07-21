//
//  EMPlayResponse.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/20.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMPlayResponse;
@protocol EMPlayResponsedelegata  <NSObject>

- (void)EMPlayResponse:(EMPlayResponse *)response progeress:(float )currentProgress;

- (NSDictionary *)EMPlayResponseFinishAnalysisResponse:(EMPlayResponse *)response;


@end


@interface EMPlayResponse : NSObject
- (id)initWithResponseData:(NSData *)data;
- (void)readAlldata;
- (NSString *)getResourcepath;
- (NSDictionary *)getResourceDict;
@end

@interface EMPlayResponManager:NSObject
+ (instancetype _Nullable )sharedManager;
@end
