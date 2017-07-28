//
//  EMPlayDataModel.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/19.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMPlayDataModel : NSObject
@property (nonatomic, strong) NSString *titleVlaue;
@property (nonatomic, strong) NSArray *picstrarray;
@property (nonatomic, strong) NSString *voicepath;
@property (nonatomic, strong) NSString *stockCode;
@property (nonatomic, strong) NSDictionary *timeDict;
- (id) initWithDicValue:(NSDictionary *)dict;
@end
