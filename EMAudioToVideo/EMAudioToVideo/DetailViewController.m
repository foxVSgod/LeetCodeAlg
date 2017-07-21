//
//  DetailViewController.m
//  WMVideoPlayer
//
//  Created by 郑文明 on 16/2/1.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "DetailViewController.h"
#import "EMStockPlayView.h"
#import "Masonry.h"
#import "EMPlayCellView.h"

@interface DetailViewController ()<EMStockPlayerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    EMStockPlayView  *stockPlayer;
    CGRect     playerFrame;
    BOOL isHiddenStatusBar;//记录状态的隐藏显示
}
@property (nonatomic, strong) UICollectionView *listCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *listlayout;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *tilleTimelb;
@end

static NSString *DetailCellIndentify = @"DetailCellIndentify";

@implementation DetailViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden{
    if (isHiddenStatusBar) {//隐藏
        return YES;
    }
    return NO;
}
//视图控制器实现的方法
- (BOOL)shouldAutorotate{
    //是否允许转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIInterfaceOrientationMask result = [super supportedInterfaceOrientations];
    //viewController所支持的全部旋转方向
    return result;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    //对于present出来的控制器，要主动的更新一个约束，让wmPlayer全屏，更安全
    if (stockPlayer.isFullscreen==NO) {
        [stockPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
            make.center.equalTo(stockPlayer.superview);
        }];
        stockPlayer.isFullscreen = YES;
        self.enablePanGesture = NO;
    }
    return UIInterfaceOrientationLandscapeRight;
}

- (void)wmplayer:(EMStockPlayView *)stockplayer clickedCloseButton:(UIButton *)closeBtn{
    if (stockplayer.isFullscreen) {
        //强制翻转屏幕，Home键在下边。
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];
        
        [stockPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.height.equalTo(@(playerFrame.size.height));
        }];
        stockPlayer.isFullscreen = NO;
        self.enablePanGesture = YES;
    }else{
        [self releaseWMPlayer];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}
///播放暂停
-(void)wmplayer:(EMStockPlayView *)stockplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    NSLog(@"clickedPlayOrPauseButton");
}

///全屏按钮
-(void)wmplayer:(EMStockPlayView *)stockplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (stockPlayer.isFullscreen==YES) {//全屏
        //强制翻转屏幕，Home键在下边。
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
        
        stockPlayer.isFullscreen = NO;
        self.enablePanGesture = YES;

        }else{//非全屏
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
            stockPlayer.isFullscreen = YES;
            self.enablePanGesture = NO;
    }
}
///单击播放器
-(void)wmplayer:(EMStockPlayView *)stockplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    
}
///双击播放器
-(void)wmplayer:(EMStockPlayView *)stockplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
///播放状态

-(void)wmplayerFailedPlay:(EMStockPlayView *)stockplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(EMStockPlayView *)stockplayer WMPlayerStatus:(WMPlayerState)state{
//    NSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(EMStockPlayView *)stockplayer{
    NSLog(@"wmplayerDidFinishedPlay");
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(EMStockPlayView *)stockplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    isHiddenStatusBar = isHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (stockPlayer==nil||stockPlayer.superview==nil){
        return;
    }

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
            stockPlayer.isFullscreen = NO;
            self.enablePanGesture = NO;
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self toOrientation:UIInterfaceOrientationPortrait];
            stockPlayer.isFullscreen = NO;
            self.enablePanGesture = YES;

        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                stockPlayer.isFullscreen = YES;
            self.enablePanGesture = NO;

        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
            stockPlayer.isFullscreen = YES;
            self.enablePanGesture = NO;
        }
            break;
        default:
            break;
    }
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    if (orientation ==UIInterfaceOrientationPortrait) {//
        [stockPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_bottom).with.offset(-1);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.height.equalTo(@(playerFrame.size.height));
        }];
    }else{
        [stockPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
            make.center.equalTo(stockPlayer.superview);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidAppear:animated];
}

- (void)createHeadVeies{
    self.title = @"个股播放器";
    self.headView = [[UIView alloc] init];
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@(100));
    }];

    self.titleLb = [[UILabel alloc] init];
    [self.view addSubview:self.titleLb];
    self.titleLb.text = @"标题";
    self.titleLb.textColor = [UIColor blackColor];
    self.titleLb.textAlignment = NSTextAlignmentLeft;
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView).with.offset(10);
        make.left.equalTo(self.headView).with.offset(5);
        make.right.equalTo(self.headView).with.offset(0);
        make.height.equalTo(@(30));

    }];

    self.tilleTimelb = [[UILabel alloc] init];
    self.tilleTimelb.text = @"更新时间";
    self.tilleTimelb.textColor = [UIColor blackColor];
    self.tilleTimelb.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.tilleTimelb];
    [self.tilleTimelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).with.offset(5);
        make.left.equalTo(self.headView).with.offset(5);
        make.right.equalTo(self.headView).with.offset(0);
        make.height.equalTo(@(30));
    }];

}

#pragma mark
#pragma mark viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    playerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width)* 9 / 16);

    [self createHeadVeies];
    
    stockPlayer = [[EMStockPlayView alloc] init];

    stockPlayer.delegate = self;
    stockPlayer.URLString = self.URLString;
    stockPlayer.titleLabel.text = self.title;
    stockPlayer.closeBtn.hidden = NO;

    [self.view addSubview:stockPlayer];
    [stockPlayer play];
 
    [stockPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).with.offset(-1);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@(playerFrame.size.height));
    }];

    self.listlayout = [[UICollectionViewFlowLayout alloc] init];

    self.listCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.listlayout];
    [self.view addSubview:self.listCollectView];

    [self.listCollectView registerClass:[EMPlayCellView class] forCellWithReuseIdentifier:DetailCellIndentify];
    self.listCollectView.delegate = self;
    self.listCollectView.dataSource = self;
    self.listCollectView.showsVerticalScrollIndicator = YES;
    self.listCollectView.backgroundColor = [UIColor grayColor];

    [self.listCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stockPlayer.mas_bottom).offset(1);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@(120));
    }];
    
    self.listlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.listlayout.minimumLineSpacing = 1;
    self.listlayout.minimumInteritemSpacing = 1;
    self.listlayout.itemSize = CGSizeMake( 208, 117);
    //测试代码
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"测试" message:@"关闭播放器" preferredStyle:UIAlertControllerStyleAlert];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if (self.presentingViewController) {
//                [self dismissViewControllerAnimated:YES completion:^{
//                }];
//            }else{
//                if (stockPlayer.isFullscreen) {//由于是push出来的，所以如果在全屏状态下，先转为非全屏（也就是人像模式Portrait）
//                    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//                    [self toOrientation:UIInterfaceOrientationPortrait];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self.navigationController popViewControllerAnimated:YES];
//                    });
//
//                }else{
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }
//        }]];
//        [self presentViewController:alertVC animated:YES completion:^{
//        }];
//    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  22;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMPlayCellView *tempcell = [collectionView dequeueReusableCellWithReuseIdentifier:DetailCellIndentify forIndexPath:indexPath];
    if (tempcell) {
        [tempcell setImageUrl:[NSString stringWithFormat:@"幻灯片%ld.JPG",indexPath.row + 1]];
    }
    return tempcell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)releaseWMPlayer
{
    [stockPlayer pause];
    [stockPlayer removeFromSuperview];
    stockPlayer = nil;
}

- (void)dealloc
{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DetailViewController deallco");
}

@end
