//
//  EMStockPlayView.h
//  EMStockPlayDemo
//
//  Created by rongrong you on 2017/7/17.
//  Copyright © 2017年 rongrong you. All rights reserved.
//

@import MediaPlayer;
@import AVFoundation;
@import UIKit;
#import "EMPlayDataModel.h"
// 播放器的几种状态
typedef NS_ENUM(NSInteger, WMPlayerState) {
    WMPlayerStateFailed,        // 播放失败
    WMPlayerStateBuffering,     // 缓冲中
    WMPlayerStatePlaying,       // 播放中
    WMPlayerStateStopped,        //暂停播放
    WMPlayerStateFinished,        //暂停播放
    WMPlayerStatePause,       // 暂停播放
};
// 枚举值，包含播放器左上角的关闭按钮的类型
typedef NS_ENUM(NSInteger, CloseBtnStyle){
    CloseBtnStylePop, //pop箭头<-
    CloseBtnStyleClose  //关闭（X）
};

//手势操作的类型
typedef NS_ENUM(NSUInteger,WMControlType) {
    progressControl,//视频进度调节操作
    voiceControl,//声音调节操作
    lightControl,//屏幕亮度调节操作
    noneControl//无任何操作
} ;
@class EMStockPlayView;
@protocol EMStockPlayerDelegate <NSObject>
@optional
///播放器事件
//点击播放暂停按钮代理方法
-(void)wmplayer:(EMStockPlayView *)stockplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn;
//点击关闭按钮代理方法
-(void)wmplayer:(EMStockPlayView *)stockplayer clickedCloseButton:(UIButton *)closeBtn;
//点击全屏按钮代理方法
-(void)wmplayer:(EMStockPlayView *)stockplayer clickedFullScreenButton:(UIButton *)fullScreenBtn;
//单击WMPlayer的代理方法
-(void)wmplayer:(EMStockPlayView *)stockplayer singleTaped:(UITapGestureRecognizer *)singleTap;
//双击WMPlayer的代理方法
-(void)wmplayer:(EMStockPlayView *)stockplayer doubleTaped:(UITapGestureRecognizer *)doubleTap;
//WMPlayer的的操作栏隐藏和显示
-(void)wmplayer:(EMStockPlayView *)stockplayer isHiddenTopAndBottomView:(BOOL )isHidden;
///播放状态
//播放失败的代理方法
-(void)wmplayerFailedPlay:(EMStockPlayView *)stockplayer WMPlayerStatus:(WMPlayerState)state;
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(EMStockPlayView *)stockplayer WMPlayerStatus:(WMPlayerState)state;
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(EMStockPlayView *)wmplayer;
@end

@interface EMStockPlayView : UIView

/** 播放器的代理 */
@property (nonatomic, weak)id <EMStockPlayerDelegate> delegate;
/**
 *  底部操作工具栏
 */
@property (nonatomic,retain ) UIImageView         *bottomView;
/**
 *  顶部操作工具栏
 */
@property (nonatomic,retain ) UIImageView         *topView;
/**
 *  是否使用手势控制音量
 */
@property (nonatomic,assign) BOOL  enableVolumeGesture;
/**
 *  是否使用手势控制音量
 */
@property (nonatomic,assign) BOOL  enableFastForwardGesture;
/**
 *  显示播放视频的title
 */
@property (nonatomic,strong) UILabel        *titleLabel;
/**
 ＊  播放器状态
 */
@property (nonatomic, assign) WMPlayerState   state;
/**
 ＊  播放器左上角按钮的类型
 */
@property (nonatomic, assign) CloseBtnStyle   closeBtnStyle;
/**
 *  定时器
 */
@property (nonatomic, retain) NSTimer        *autoDismissTimer;
/**
 *  BOOL值判断当前的状态
 */
@property (nonatomic,assign ) BOOL            isFullscreen;
/**
 *  控制全屏的按钮
 */
@property (nonatomic,retain ) UIButton       *fullScreenBtn;
/**
 *  播放暂停按钮
 */
@property (nonatomic,retain ) UIButton       *playOrPauseBtn;
/**
 *  左上角关闭按钮
 */
@property (nonatomic,retain ) UIButton       *closeBtn;
/**
 *  显示加载失败的UILabel
 */

@property (nonatomic,strong) UILabel        *loadFailedLabel;


/**
 *  /给显示亮度的view添加毛玻璃效果
 */
@property (nonatomic, strong) UIVisualEffectView * effectView;
/**
 *  wmPlayer内部一个UIView，所有的控件统一管理在此view中
 */
@property (nonatomic,strong) UIView        *contentView;


/**
 *  菊花（加载框）
 */
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;

/**
 *  设置播放视频的USRLString，可以是本地的路径也可以是http的网络路径
 */
@property (nonatomic,copy) NSString       *URLString;
/**
 *  跳到time处播放
 *  @param seekTime这个时刻，这个时间点
 */
@property (nonatomic, assign) double  seekTime;

/** 播放前占位图片，不设置就显示默认占位图（需要在设置视频URL之前设置） */
@property (nonatomic, copy  ) UIImage              *placeholderImage ;

///---------------------------------------------------


/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/**
 *  获取正在播放的时间点
 *
 */


 /**
 *  获取正在播放的时间点
 *
 *  @return double的一个时间点
 */
- (double)currentTime;

/**
 * 重置播放器
 */
- (void )resetWMPlayer;
/**
 * 版本号
 */
- (NSString *)version;
/**
 * 设置播发的数据
 */
- (void)setNewDataView:(EMPlayDataModel *)dataModel;
//获取当前的旋转状态
+(CGAffineTransform)getCurrentDeviceOrientation;

@end
