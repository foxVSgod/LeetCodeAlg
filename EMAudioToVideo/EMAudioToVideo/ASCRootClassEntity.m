//
//	ASCRootClassEntity.m
//
//	Create by rongrong you on 27/7/2017
//	Copyright © 2017 . All rights reserved.
//	Entity generated using AliEntity Tool
//

#import "ASCRootClassEntity.h"
#import "ASCDataEntity.h"

@implementation ASCRootClassEntity
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = [dic objectForKey:@"code"];
        self.data = [[ASCDataEntity alloc] initWithDic:[dic objectForKey:@"data"]];
        self.message = [dic objectForKey:@"message"];
        self.status = [dic objectForKey:@"status"];
    }
    return  self;
}
@end
