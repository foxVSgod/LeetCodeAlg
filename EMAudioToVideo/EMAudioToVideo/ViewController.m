//
//  ViewController.m
//  EMStockPlayDemo
//
//  Created by rongrong you on 2017/7/17.
//  Copyright © 2017年 rongrong you. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;
@import AVFoundation;
@interface ViewController ()
@property (nonatomic, strong) NSString *localfilePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAvbyPictures];
    // Do any additional setup after loading the view, typically from a nib.
}



- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status =CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);

    NSParameterAssert(status ==kCVReturnSuccess && pxbuffer !=NULL);

    CVPixelBufferLockBaseAddress(pxbuffer,0);
    void *pxdata =CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);

    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context =CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pxbuffer,0);

    return pxbuffer;
}

- (void)createAvbyPictures{
    NSMutableArray *picarray = [[NSMutableArray alloc]initWithObjects:
                                [UIImage imageNamed:@"幻灯片1.JPG"],[UIImage imageNamed:@"幻灯片2.JPG"],[UIImage imageNamed:@"幻灯片3.JPG"],[UIImage imageNamed:@"幻灯片4.JPG"],[UIImage imageNamed:@"幻灯片5.JPG"],[UIImage imageNamed:@"幻灯片6.JPG"],[UIImage imageNamed:@"幻灯片7.JPG"],[UIImage imageNamed:@"幻灯片8.JPG"],[UIImage imageNamed:@"幻灯片9.JPG"],[UIImage imageNamed:@"幻灯片10.JPG"],[UIImage imageNamed:@"幻灯片11.JPG"],[UIImage imageNamed:@"幻灯片12.JPG"],[UIImage imageNamed:@"幻灯片13.JPG"],[UIImage imageNamed:@"幻灯片14.JPG"],[UIImage imageNamed:@"幻灯片15.JPG"],[UIImage imageNamed:@"幻灯片16.JPG"],[UIImage imageNamed:@"幻灯片17.JPG"],[UIImage imageNamed:@"幻灯片18.JPG"],[UIImage imageNamed:@"幻灯片19.JPG"],[UIImage imageNamed:@"幻灯片20.JPG"],[UIImage imageNamed:@"幻灯片21.JPG"],[UIImage imageNamed:@"幻灯片22.JPG"],[UIImage imageNamed:@"幻灯片23.JPG"],nil];
    NSArray *timeArray = [NSArray arrayWithObjects:@"7.66",@"4.6",@"28.56",@"58",@"4.86",@"4.9",@"21.64",@"17.46",@"10.68",@"17.92",@"25.8",@"30.4",@"4.02",@"25.94",@"3.68",@"20.2",@"33.14",@"4.32",@"2.86",@"2.62",@"29.92",@"5.66",@"4.44"];

    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    self.localfilePath= [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",@"test"]];
    NSString *moviePath = self.localfilePath;
    UIImage *tempImage = [UIImage imageNamed:@"幻灯片1.JPG"];
    CGSize size = tempImage.size;//定义视频的大小
    NSError *error =nil;
    unlink([moviePath UTF8String]);
    NSLog(@"path->%@",moviePath);
    //—-initialize compression engine
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:moviePath]
                                                         fileType:AVFileTypeQuickTimeMovie
                                                            error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error =%@", [error localizedDescription]);

    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    AVAssetWriterInput *writerInput =[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];

    NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];

    //+ (instancetype)assetWriterInputPixelBufferAdaptorWithAssetWriterInput:(AVAssetWriterInput *)input sourcePixelBufferAttributes:(nullable NSDictionary<NSString *, id> *)sourcePixelBufferAttributes;
    AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor
                                                    assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);

    if ([videoWriter canAddInput:writerInput])
        NSLog(@"11111");
    else
        NSLog(@"22222");

    [videoWriter addInput:writerInput];

    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];

    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;

    NSMutableArray *tempTimes = [NSMutableArray array];
    NSInteger totalTimes = 0;
    for (NSString *tempTime in timeArray){
        NSInteger newTime = (tempTime.floatValue * 10);
        totalTimes = totalTimes + newTime;
        [tempTimes addObject:[NSNumber numberWithInteger:totalTimes]];
    }
        int __block currentIndex = 0;

    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData]){
            if(++frame >= totalTimes || currentIndex >= tempTimes.count){
                [writerInput markAsFinished];
                [videoWriter finishWriting];
                break;
            }
            CVPixelBufferRef buffer =NULL;

            buffer =(CVPixelBufferRef)[self pixelBufferFromCGImage:[[picarray objectAtIndex:currentIndex] CGImage] size:size];

            if (buffer)
                {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,10)])
                    NSLog(@"FAIL");
                else
                    NSLog(@"OK");
                CFRelease(buffer);
                }
            }
        NSNumber *currnettime = [tempTimes objectAtIndex:currentIndex];
        if (frame >= currnettime.integerValue) {
            currentIndex = currentIndex + 1;
        }
    }];
    NSLog(@"path->%@",self.localfilePath);
}


@end
