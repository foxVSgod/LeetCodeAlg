//
//  EMPlayResponse.h
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/20.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EMAudioAnalysisCompletedBlock)( NSString *_Nullable audioFilepath,NSArray *_Nullable imagepathArray, NSDictionary *_Nullable timeDict,NSError * _Nullable error, BOOL finished);

@interface EMPlayResponse : NSObject
- (id _Nullable )initWithResponseFilepath:(NSURL*_Nullable)locationUrl NS_DESIGNATED_INITIALIZER;
- (void)setAnalysisCompleteBlock:(EMAudioAnalysisCompletedBlock _Nullable )finishedBlock;
- (BOOL)AnalyzeAlldata;
- (NSString *_Nullable)getfilebasepath;
@end

