//
//  Created by 小阎王 on 2019/8/26.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "AppDelegate.h"

#import <Flutter/Flutter.h>

#import "GeneratedPluginRegistrant.h"

#import "FlutterMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    FlutterMainViewController* flutterMainViewController = [[FlutterMainViewController alloc] init];
    
    UINavigationController* rootViewController = [[UINavigationController alloc]initWithRootViewController:flutterMainViewController];
    
    [rootViewController setNavigationBarHidden:YES];
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:1.0];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
