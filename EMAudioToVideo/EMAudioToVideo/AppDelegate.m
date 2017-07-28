//
//  AppDelegate.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "AppDelegate.h"
#import "EMBaseNavigationController.h"
#import "DetailViewController.h"
#import "EMPlayResponse.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    DetailViewController *rootViewcontroller = [[DetailViewController alloc] init];
    ViewController *tempView = [[ViewController alloc] init];
    EMBaseNavigationController *rootNagationcontroller = [[ EMBaseNavigationController alloc] initWithRootViewController:tempView];
    self.window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootNagationcontroller;
    self.window.backgroundColor = [UIColor clearColor];
    //设置背景颜色  将该UIWindow对象设为主窗口、并显示出来
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}
@end
