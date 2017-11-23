//
//  AppDelegate+JKRRootViewController.m
//  JKRSearchDemo
//
//  Created by Lucky on 2017/4/4.
//  Copyright © 2017年 Lucky. All rights reserved.
//

#import "AppDelegate+JKRRootViewController.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "ViewController.h"
@implementation AppDelegate (JKRRootViewController)

- (void)jkr_configRootViewController {
    MainViewController*RootVc =[[MainViewController alloc]init];
    UINavigationController*RootNav =[[UINavigationController alloc]initWithRootViewController:RootVc];
    self.window.rootViewController =RootNav;
}

@end
