//
//  EMPlayResponse.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/20.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMPlayResponse : NSObject
- (id)initWithResponseData:(NSData *)data;
- (void)readAlldata;
- (NSString *)getResourcepath;
- (NSDictionary *)getResourceDict;

@end
