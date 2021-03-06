/*!
 @header BaseNavigationController.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/1/19
 
 @version 1.00 16/1/19 Creation(版本信息)
 
   Copyright © 2016年 郑文明. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EMBaseNavigationController : UINavigationController
@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;


@end
