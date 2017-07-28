//
//	ASCDataEntity.h
//
//	Create by rongrong you on 27/7/2017
//	Copyright © 2017 . All rights reserved.
//	Entity generated using AliEntity Tool
//

#import <Foundation/Foundation.h>
#import "EMStockInfoModel.h"
@interface ASCDataEntity : NSObject
@property (nonatomic, copy) NSString *bag_address;
@property (nonatomic, copy) NSString *error_info;
@property (nonatomic, copy) NSNumber *error_no;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *secucode;
@property (nonatomic, copy) NSString *secuname;
@property (nonatomic, copy) NSArray <EMStockInfoModel *>  *tag_data;
@property (nonatomic, copy) NSString *top_pic;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *video_address;
- (id)initWithDic:(NSDictionary *)dic;
@end
