//
//  EMPlayResponse.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/20.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMPlayResponse.h"

@interface EMPlayResponse(){
}
@property (nonatomic, strong) NSData *response;
@property (nonatomic, assign) NSInteger pointIndex;
@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) NSString *filepath;

- (int8_t)readUnit8Bit;

- (int16_t)readUnit16Bit;

- (int32_t)readUnit32Bit;

- (int64_t)readUnit64Bit;

- (NSData *)readdataBylength:(NSInteger )datalength;
@end

@implementation EMPlayResponse

- (id)initWithResponseData:(NSData *)data{
    self = [super init];
    if (self) {
        self.response = [[NSData alloc] initWithData:data];
        self.pointIndex = 0;
    }
    return self;
}

- (NSData *)getCurrentReadData:(NSData *)data size:(NSUInteger)currentReadDataLength;
{
    if ([data length] < self.pointIndex + currentReadDataLength)
        {
        return nil;
        }
    NSData *currentReadData = [self.response subdataWithRange:NSMakeRange(self.pointIndex, currentReadDataLength)];
    self.pointIndex += currentReadDataLength;
    return currentReadData;
}

- (int8_t)readUnit8Bit{
    NSData *currentReadData = [self getCurrentReadData:self.response size:sizeof(int8_t)];
    int8_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}

- (int16_t)readUnit16Bit{
    NSData *currentReadData = [self getCurrentReadData:self.response size:sizeof(int16_t)];
    int16_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}


- (int32_t)readUnit32Bit{
    NSData *currentReadData = [self getCurrentReadData:self.response size:sizeof(int8_t)];
    int8_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}


- (int64_t)readUnit64Bit{
    NSData *currentReadData = [self getCurrentReadData:self.response size:sizeof(int8_t)];
    int8_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}

- (NSData *)readdataBylength:(NSInteger )datalength{
    NSData *curentReadData = [self getCurrentReadData:self.response size:datalength];
    if (curentReadData) {
        return curentReadData;
    }else{
        return [[NSData alloc] init];
    }
}

@end
