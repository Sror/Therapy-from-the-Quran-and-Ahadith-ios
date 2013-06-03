//
//  NYSliderPopover.h
//  NYReader
//
//  Created by Cassius Pacheco on 21/12/12.
//  Copyright (c) 2012 Nyvra Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYPopover.h"

@protocol NYSliderPopoverDelegate <NSObject>

- (void) sliderDidEndSliding;

@end

@interface NYSliderPopover : UISlider

@property (nonatomic, strong) NYPopover *popover;
@property (assign) id <NYSliderPopoverDelegate> delegate;

- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;
- (void)hidePopoverAnimated:(BOOL)animated;

@end
