//
//	ASCRootClassEntity.h
//
//	Create by rongrong you on 27/7/2017
//	Copyright © 2017 . All rights reserved.
//	Entity generated using AliEntity Tool
//

#import <Foundation/Foundation.h>
#import "ASCDataEntity.h"

@interface ASCRootClassEntity : NSObject

@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) ASCDataEntity *data;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSNumber *status;
- (id)initWithDic:(NSDictionary *)dic;
@end
