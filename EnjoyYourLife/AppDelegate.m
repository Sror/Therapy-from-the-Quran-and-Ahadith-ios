//
//  AppDelegate.m
//  EnjoyYourLife
//
//  Created by RAC on 2/19/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "SplashView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DataSource checkAndCreateDatabase];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.viewController.showCoverPage = YES;
    self.viewController.coverPageImageView.hidden =NO;
    self.navController = [[DTNavigationController alloc]initWithRootViewController:self.viewController];
    
//    [self.navController.navigationBar  setBarStyle:UIBarStyleBlackTranslucent];
    
    [self.navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"control-bg.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:self.navController.navigationBar.frame];
    [titleLabel setText:@"Therapy from Quran and Ahadith"];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navController.navigationItem setTitleView:titleLabel];
    
    
    
    // check application first run
    
     self.defaults = [NSUserDefaults standardUserDefaults];
    BOOL appAlreadyRun = [self.defaults boolForKey:@"FirstRun"];
    
    if(appAlreadyRun == NO){
        [self.defaults setObject:@"Helvetica" forKey:@"FontFamily"];
        [self.defaults setObject:[NSNumber numberWithInt:18] forKey:@"FontSize"];
        [self.defaults setObject:@"Black" forKey:@"FontColor"];
        [self.defaults setBool:YES forKey:@"FirstRun"];
    }
    int chID =[self.defaults integerForKey:@"chID"];
    int top = [self.defaults integerForKey:@"top"];
    if (chID>0 && top>=0 ) //&& [cont isKindOfClass:[coreViewController class]])
    {
         coreViewController *core = [[coreViewController alloc]init] ;
        [core gotoSavedChapter:chID top:top];
        [self.navController pushViewController:core animated:YES];
    }
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    // show splash
    [self showSplashView];
    
    return YES;
}

- (void) showSplashView{
    self.splash = [[SplashView alloc]initWithFrame:self.window.frame];
    self.splash.delay = 2.0;
    self.splash.touchAllowed = YES;
    self.splash.animation = SplashViewAnimationFade;
    [self.splash startSplash];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
 //   NSLog(@"Application will resign active");
   id cont= self.navController.topViewController ;
    if ([cont isKindOfClass:[coreViewController class]]) {
        
        coreViewController * core = (coreViewController*)cont;
        int chID = core.ChID;
        [self.defaults setInteger:chID forKey:@"chID"];
        [self.defaults setInteger:core.top forKey:@"top"];
         [self.defaults synchronize];
    
    }
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   // NSLog(@"Application will enter foreground");
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
