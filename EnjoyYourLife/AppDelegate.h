//
//  AppDelegate.h
//  EnjoyYourLife
//
//  Created by RAC on 2/19/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNavigationController.h"

@class ViewController;
@class SplashView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DTNavigationController * navController;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) SplashView * splash;

@property NSUserDefaults * defaults;
@end
