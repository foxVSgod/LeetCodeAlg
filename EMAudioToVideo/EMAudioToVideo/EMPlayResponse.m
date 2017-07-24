//
//  EMPlayResponse.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/20.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMPlayResponse.h"
@import Foundation;
@import UIKit;

#define ImageNamePrefix   @"EMStockImageName"
@interface EMPlayResponse(){

}
@property (nonatomic, strong) NSURL *dataFilepath;
@property (nonatomic, strong) NSData *reponseData;
@property (nonatomic, assign) NSInteger pointIndex;
@property (nonatomic, strong) NSArray  *picArray;
@property (nonatomic, strong) NSString *audiofilepath;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) NSInteger objectCount;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSMutableDictionary *playtimeDic;
@property (nonatomic, strong) NSMutableArray *pictPathArray;
@property (nonatomic, strong) NSString *imageBaseUrl;
@property (nonatomic, copy) EMAudioAnalysisCompletedBlock completeBlock;

- (int8_t)readUnit8Bit;
- (int16_t)readUnit16Bit;
- (int32_t)readUnit32Bit;
- (int64_t)readUnit64Bit;
- (NSData *)readdataBylength:(NSInteger )datalength;
@end

@implementation EMPlayResponse

- (id)init{
   return  [self initWithResponseFilepath:nil];
}

- (id)initWithResponseFilepath:(NSURL*)locationUrl{
    self = [super init];
    if (self) {
        self.dataFilepath = [locationUrl copy];
        self.pictPathArray = [NSMutableArray array];
        self.pointIndex = 0;
    }
    return self;
}

- (NSString *)getResourcepath{
    if (self.imageBaseUrl) {
        return self.imageBaseUrl;
    }else{
        NSString *path_sandox = NSTemporaryDirectory();;
        self.imageBaseUrl = [path_sandox stringByAppendingString:@"StockResource/"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.imageBaseUrl]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[path_sandox stringByAppendingString:@"StockResource"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return self.imageBaseUrl;
    }
}

- (NSString *)getfilebasepath{
    return [self getResourcepath];
}

- (NSDictionary *)getResourceDict{
    if (self.playtimeDic) {
        return [NSDictionary dictionaryWithDictionary:self.playtimeDic];
    }else{
        return [NSDictionary dictionary];
    }
}

- (void)setAnalysisCompleteBlock:(EMAudioAnalysisCompletedBlock)finishedBlock{
    self.completeBlock = [finishedBlock copy];
}

- (BOOL)AnalyzeAlldata{
    NSData *responsedata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testrespon" ofType:@"dat"]];
    self.reponseData =[[NSData alloc] initWithData:responsedata];
    self.version = [self readUnit32Bit];
    self.objectCount = [self readUnit32Bit];
    self.imageCount = 0;
    self.playtimeDic = [NSMutableDictionary dictionary];
     NSString *path_sandox = NSTemporaryDirectory();;
    self.imageBaseUrl = [path_sandox stringByAppendingString:@"StockResource/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.imageBaseUrl]) {
          [[NSFileManager defaultManager] createDirectoryAtPath:[path_sandox stringByAppendingString:@"StockResource"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL objectIndex = 0;
    while (self.pointIndex <= self.reponseData.length) {
        short filetype = [self readUnit8Bit];
        if (filetype == 1) {
            NSInteger filelength = [self readUnit64Bit];
            if (filelength + self.pointIndex <= self.reponseData.length) {
                NSData *wavdata = [self readdataBylength:filelength];
                if (wavdata) {
                    self.audiofilepath = [ self.imageBaseUrl stringByAppendingString:@"stockAudio.wav"];
                    [wavdata writeToFile: self.audiofilepath atomically:YES];
                }
            }
        }else if (filetype ==2){
            NSInteger piclength = [self readUnit64Bit];
            if (piclength + self.pointIndex <= self.reponseData.length) {
                NSData *wavdata = [self readdataBylength:piclength -4];
                NSInteger playtime = [self readUnit32Bit];
                if (wavdata) {
                    self.imageCount = self.imageCount + 1;
                    UIImage *tempImage = [UIImage imageWithData:wavdata];
                    NSString *imageNamestr =[NSString stringWithFormat:@"%@-%ld.png",ImageNamePrefix,self.imageCount];
                    NSString *imagePath = [self.imageBaseUrl stringByAppendingString:[NSString stringWithFormat:@"%@",imageNamestr]];
                    [UIImagePNGRepresentation(tempImage) writeToFile:imagePath atomically:YES];
                    [_playtimeDic setObject:[NSNumber numberWithInteger:playtime] forKey:imageNamestr];
                    [self.pictPathArray addObject:imageNamestr];
                }
            }
        }
        objectIndex = objectIndex + 1;
    }
     NSInteger chechNum = [self readUnit32Bit];
    BOOL success = chechNum == self.version;
    NSError *error = nil;
    if (!success) {
//        error = [NSError alloc] initWithDomain:<#(nonnull NSErrorDomain)#> code:<#(NSInteger)#> userInfo:<#(nullable NSDictionary *)#>
    }
    if (self.completeBlock) {
        self.completeBlock( self.audiofilepath , self.pictPathArray, self.playtimeDic, error, success);
    }
    return success;
}

- (NSData *)getCurrentReadData:(NSData *)data size:(NSUInteger)currentReadDataLength;
{
    if ([data length] < self.pointIndex + currentReadDataLength)
        {
        return nil;
        }
    NSData *currentReadData = [self.reponseData subdataWithRange:NSMakeRange(self.pointIndex, currentReadDataLength)];
    self.pointIndex += currentReadDataLength;
    return currentReadData;
}

- (int8_t)readUnit8Bit{
    NSData *currentReadData = [self getCurrentReadData:self.reponseData size:sizeof(int8_t)];
    int8_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}

- (int16_t)readUnit16Bit{
    NSData *currentReadData = [self getCurrentReadData:self.reponseData size:sizeof(int16_t)];
    int16_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}

- (int32_t)readUnit32Bit{
    NSData *currentReadData = [self getCurrentReadData:self.reponseData size:sizeof(int32_t)];
    int32_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}

- (int64_t)readUnit64Bit{
    NSData *currentReadData = [self getCurrentReadData:self.reponseData size:sizeof(int64_t)];
    int64_t result;  //short
    [currentReadData getBytes: &result length: sizeof(result)];
    return result;
}

- (NSData *)readdataBylength:(NSInteger )datalength{
    NSData *curentReadData = [self getCurrentReadData:self.reponseData size:datalength];
    if (curentReadData) {
        return curentReadData;
    }else{
        return [[NSData alloc] init];
    }
}
@end

