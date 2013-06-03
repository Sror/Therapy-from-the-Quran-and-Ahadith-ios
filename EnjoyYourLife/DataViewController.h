//
//  DataViewController.h
//  CoreTextBasics
//
//  Created by Faiz Rasool on 3/8/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAMSettings.h"
#import "CustomTextView.h"

@interface DataViewController : UIViewController //<BAMSettingsDelegate>

@property (strong, nonatomic) UILongPressGestureRecognizer * longPressGestureRecognizer;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSMutableAttributedString * attrString;
@property (weak, nonatomic) IBOutlet CustomTextView *drawingTextView;

@property int fontSize;
@property (strong, nonatomic) NSString *fontStyle,*fontStyleBold,*foregroundColor;

@property NSRange previousTextRange;
@property NSRange currentTextRange;

- (id)initWithAttributedString:(NSAttributedString*)string;
//- (id)initWithAttributedString:(NSMutableAttributedString*)string fSize:(int)fsize fStyle:(NSString *)fStyle;
-(NSMutableAttributedString *)applyStyle:(NSString *)str titleRange:(NSRange)range;

@end
