//
//  EMStockInfoModel.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/27.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMStockInfoModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL isnew;
@property (nonatomic, strong) NSString *pic;
- (id)initWithDic:(NSDictionary *)dic;
@end
