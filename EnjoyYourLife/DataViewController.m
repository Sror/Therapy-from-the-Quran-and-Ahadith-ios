//
//  DataViewController.m
//  CoreTextBasics
//
//  Created by Faiz Rasool on 3/8/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import "DataViewController.h"


@interface DataViewController ()

@end

@implementation DataViewController

- (id)initWithAttributedString:(NSMutableAttributedString*)string //fSize:(int)fsize fStyle:(NSString *)fStyle
{
    
    self = [super init];
    if(self){
        self.attrString =  string;
        self.fontStyle = [[NSUserDefaults standardUserDefaults]objectForKey:@"FontFamily"];
        self.fontStyleBold = kHeadingFontName;
        self.fontSize = [[NSUserDefaults standardUserDefaults]floatForKey:@"FontSize"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
//    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
//    [self.drawingTextView setFont:[UIFont fontWithName:[def objectForKey:@"FontFaimly"] size:[def floatForKey:@"FontSize"]]];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.drawingTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.drawingTextView setFont:[UIFont fontWithName:self.fontStyle size:self.fontSize]];// Menlo-Regular
    self.drawingTextView.editable = NO;
    self.drawingTextView.scrollEnabled = YES;
    self.drawingTextView.textAlignment = NSTextAlignmentJustified;
    self.drawingTextView.backgroundColor = [UIColor whiteColor];
    self.drawingTextView.textColor = [UIColor blackColor];
    
//    self.drawingTextView.syntaxTokenizer = [[JLTokenizer alloc] init];
//    self.drawingTextView.syntaxTokenizer.theme = kTokenizerThemeDefault;
    
    self.drawingTextView.attributedText =self.attrString;
  //  [self.drawingTextView setAttributedString:self.attrString];
    //
    //    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShowNavBar:)];
    //    [self.view addGestureRecognizer:tapGesture];
    
    //******** shifted setting observer to core classs
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fontSizeChanged:) name:kFontSizeChangedNotification object:nil];
  
    NSString * color = [[NSUserDefaults standardUserDefaults] valueForKey:@"FontColor"];
    
    if([color caseInsensitiveCompare:@"White"] == NSOrderedSame){
        self.view.backgroundColor = [UIColor blackColor];
        self.drawingTextView.backgroundColor = [UIColor blackColor];
        self.drawingTextView.textColor = [UIColor whiteColor];
    }
    else{
        self.view.backgroundColor = [UIColor whiteColor];
        self.drawingTextView.backgroundColor = [UIColor whiteColor];
        self.drawingTextView.textColor = [UIColor blackColor];
    }
}

- (void) hideShowNavBar:(UITapGestureRecognizer*)sender{
   // NSLog(@"DataController fired the gesture.");
}

- (void) fontSizeChanged:(NSNotification*)notif{
    NSNumber * size = (NSNumber*)notif.object;
    self.fontSize = size.intValue;
    [self.drawingTextView setFont:[UIFont fontWithName:self.fontStyle size:[size intValue]]];
    [self.drawingTextView setNeedsDisplay];
   // [self.drawingTextView.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)settingsDidChangeValueForKey:(NSString *)key{
//    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Its working" message:@"Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    //    [alert show];
//    NSUserDefaults *settDef = [NSUserDefaults standardUserDefaults];
//    if ([key isEqualToString:@"FontSize"]) {
//        self.fontSize = [settDef floatForKey:key];
//    }
//    else if([key isEqualToString:@"FontFamily"]){
//        self.fontStyle = [settDef stringForKey:key];
//        self.fontStyleBold = @"Helvetica-Bold";
//    }
//    else if ([key isEqualToString:@"FontColor"]){
//        self.foregroundColor = [settDef stringForKey:key];
//        //**** CHANGE BACKGROUND COLOR AS WELL
//        
//    }
////    self.coreViewCtrl =[[coreViewController alloc]init];
//    [self.coreViewCtrl onSettingChanged];
//
//}

-(NSMutableAttributedString *)applyStyle:(NSString *)str titleRange:(NSRange)range
{
    @try {
    
    
    UIFont * font = [UIFont fontWithName:self.fontStyle size:self.fontSize];
    UIFont * headingFont = [UIFont fontWithName:kHeadingFontName size:self.fontSize];
   
      
    NSMutableAttributedString *attstr =[[NSMutableAttributedString alloc ] initWithString:str];

    if (range.location != NSNotFound) {
        [attstr addAttribute:NSFontAttributeName value:headingFont range:range];
        [attstr addAttribute:NSFontAttributeName value:font range:NSMakeRange(range.length,[attstr length]-range.length)];
        
    }
    else
    {
        [attstr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];        
        
    }
    
    /*
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)(self.fontStyle),self.fontSize, NULL);
    CTFontRef Headingfont = CTFontCreateWithName((__bridge CFStringRef)self.fontStyleBold,self.fontSize, NULL);
    CTFontRef helvetica = CTFontCreateWithName((__bridge CFStringRef)(self.fontStyle), self.fontSize, NULL);
    
    //
    //    NSString *fontName = (__bridge NSString *)CTFontCopyName(font, kCTFontPostScriptNameKey);
    //    CGFloat fontSize = CTFontGetSize(font);
    //    UIFont * fnt = [UIFont fontWithName:fontName size:fontSize];
    //
    //    CGSize textSize = [@"A" sizeWithFont:fnt constrainedToSize:CGSizeMake(300, 500)];
    //    self.drawingTextView.lineHeight = textSize.height+10; //minimumLineHeight;
    ////     self.drawingTextView._charWidth = [@"A" sizeWithFont:(__bridge UIFont *)(font)].width;
    //
    //    CGFloat minimumLineHeight =textSize.height,maximumLineHeight = minimumLineHeight;
    //    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    ////
    //    //Apply paragraph settings
    //    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    //
    //    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[4]){
    //        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    //        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
    //        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
    //        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    //    },4);
    
    //applying font
    NSMutableAttributedString *attstr =[[NSMutableAttributedString alloc ] initWithString:str];
    //    [attstr addAttribute:(id)kCTParagraphStyleAttributeName
    //                   value:(__bridge id)(style)
    //                   range:NSMakeRange(0, [attstr length])];
    
    //    NSRange range=[attstr.string rangeOfString:self.chTitle];
    if (range.location != NSNotFound) {
        [attstr addAttribute:(id)kCTFontAttributeName
                       value:(__bridge id)Headingfont
                       range:range];//NSMakeRange(0, [self.chTitle length])];
        [attstr addAttribute:(id)kCTForegroundColorAttributeName
                       value:(id)[UIColor blackColor]
                       range:range];
        
        
        //applying font
        [attstr addAttribute:(id)kCTFontAttributeName
                       value:(__bridge id)font
                       range:NSMakeRange(range.length,[attstr length]-range.length)];
        
    }
    else
    {
        [attstr addAttribute:(id)kCTFontAttributeName
                       value:(__bridge id)helvetica
                       range:NSMakeRange(0,[attstr length])];
        
        
    }
    CFRelease(font);
    CFRelease(helvetica);
    CFRelease(Headingfont);
    return attstr;
     */
    return attstr;
    }
    @catch (NSException *exception) {
        [DataSource showAllert:exception.description];
    }
    @finally {
        
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        self.drawingTextView.frame = CGRectMake(0, 0, bounds.size.height,bounds.size.width);
        self.drawingTextView.text = self.attrString.string;
        //        [self.drawingTextView setAttributedString: self.attrString];
        
        [self.view setNeedsDisplay];
    }
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        
        self.drawingTextView.frame = [[UIScreen mainScreen]bounds];
        
        self.drawingTextView.text = self.attrString.string;
        //        [self.drawingTextView setAttributedString: self.attrString];
        [self.view setNeedsDisplay];
    }
    
    
}

#pragma mark - UIGestureRecognizer

- (void) handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:self.view];
   // NSLog(@"point is x= %f, y= %f",p.x,p.y);
}

- (void)viewDidUnload {
//    [self setDrawingView:nil];
    [super viewDidUnload];
}
@end