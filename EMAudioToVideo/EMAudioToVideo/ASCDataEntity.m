//
//	ASCDataEntity.m
//
//	Create by rongrong you on 27/7/2017
//	Copyright © 2017 . All rights reserved.
//	Entity generated using AliEntity Tool
//

#import "EMPlayDataModel.h"
#import "EMStockInfoModel.h"
#import "ASCDataEntity.h"

@implementation ASCDataEntity
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.bag_address = [dic objectForKey:@"bag_address"];
        self.error_info = [dic objectForKey:@"error_info"];

        self.filename = [dic objectForKey:@"filename"];
        self.secucode = [dic objectForKey:@"secucode"];

        self.secuname = [dic objectForKey:@"secuname"];
        NSString *jsonstr = [dic objectForKey:@"tag_data"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"}{" withString:@"},{"];

        NSData *resData = [[NSData alloc] initWithData:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray *resultarray = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *tag_dataarray = [NSMutableArray array];
        for (NSDictionary *tempdic in  resultarray) {
            EMStockInfoModel *oneplayData = [[EMStockInfoModel alloc] initWithDic:tempdic];
            [tag_dataarray addObject:oneplayData];
        }
        self.tag_data = [NSArray arrayWithArray:tag_dataarray];
        self.top_pic = [dic objectForKey:@"top_pic"];
        self.version = [dic objectForKey:@"version"];

        self.video_address = [dic objectForKey:@"video_address"];
        self.error_no = [dic objectForKey:@"error_no"];
    }
    return  self;
}
@end
