//
//  CustomTextView.m
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 4/26/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:))
        return NO;
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}


@end
