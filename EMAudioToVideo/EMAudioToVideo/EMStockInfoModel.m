//
//  EMStockInfoModel.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/27.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMStockInfoModel.h"

@implementation EMStockInfoModel
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSNumber *indexnumber = [dic objectForKey:@"index"];
        self.index = indexnumber.integerValue;
        self.tag = [dic objectForKey:@"tag"];
        self.time = [dic objectForKey:@"time"];
        NSNumber *isnewnumber = [dic objectForKey:@"isnew"];
        self.isnew = isnewnumber.boolValue;
        self.pic = [dic objectForKey:@"pic"];
    }
    return  self;
}

@end
