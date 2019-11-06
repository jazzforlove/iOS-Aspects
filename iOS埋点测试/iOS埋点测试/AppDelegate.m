//
//  AppDelegate.m
//  iOS埋点测试
//
//  Created by 李国卿 on 2019/11/4.
//  Copyright © 2019 李国卿. All rights reserved.
//

#import "AppDelegate.h"
#import "Test1ViewController.h"
#import "Aspects.h"
#import "AspectMananer.h"
#import "CocoaLumberjack.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[Test1ViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [AspectMananer trackAspectHooks];
    
    return YES;
}





@end
