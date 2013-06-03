//
//  ModelController.h
//  CoreTextBasics
//
//  Created by Faiz Rasool on 3/8/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end
