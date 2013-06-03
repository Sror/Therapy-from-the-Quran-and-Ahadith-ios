//
//  coreViewController.m
//  TestCoreText
//
//  Created by ahadnawaz on 08/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import "coreViewController.h"
#import "TOCViewController.h"
#import "NSString+Unicode.h"
#import "JLTextView.h"
#import "SearchViewController.h"
#import "ViewController.h"
#import "NYSliderPopover.h"
#import "MBProgressHUD.h"

static int chapterID;
static int childID;
int pageNumber;
static int totalChapters;
static int chapterPrefix;

@interface coreViewController ()

@end

@implementation coreViewController
@synthesize textView;
int pno=0;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //    self.navigationController.title=@"CoreText";
        // self.title =@"Enjoy Your Life";
        
        //        UIBarButtonItem *contents=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showContent:)];
        //        UIBarButtonItem *search=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar:)];
        //        UIBarButtonItem *fontSlider=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showFontBar:)];
        //        NSArray *buttons=[[NSArray alloc]initWithObjects:contents,search,fontSlider, nil];
        //        //        self.navigationItem.rightBarButtonItem=contents;
        //        self.navigationItem.rightBarButtonItems=buttons;
        
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShowNavBar:)];
        self.tapGesture.delegate = self;
        [self.view addGestureRecognizer:self.tapGesture];
        
        //
        //        UITapGestureRecognizer * toolBarGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
        //        [self.myToolbar addGestureRecognizer:toolBarGesture];
        
        //        self.dataSource =[DataSource sharedInstance];
        //        [self.dataSource dbConnection:@"DTech"];
        
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if([self.myToolbar isHidden]) // if toolbar is hidden, response to touches from everywhere on the view
        return YES;
    
    CGPoint p = [gestureRecognizer locationInView:self.fontSliderBar];
    
    if( ![self.fontSliderBar isHidden] && p.y > 0)
        return NO;
    
    
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myToolbar];
    if(touchPoint.y > 0 && touchPoint.y < 45)
        return NO;
    
    return YES;
}


//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
//{
//    if([touch.view isKindOfClass:[UIBarButtonItem class]])
//        return NO;
//    else
//        return YES;
//}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar  setBarStyle:UIBarStyleBlackTranslucent];
}


- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapterSelectdAction:) name:kChapterSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchSelectedAction:) name:kSearchSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fontSizeChanged:) name:kFontSizeChangedNotification object:nil];
    
    self.navigationItem.title = @"Enjoy Your Life";
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:50.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
    self.dataSource = [DataSource sharedInstance];
    self.bmSettings = [[BAMSettings alloc] init];
    
    self.pageSlider.delegate = self;
    //  [self.myPageSlider setFrame:CGRectMake(30, 10, 260, 25)];
    [self.pageSlider setMaximumTrackTintColor:[UIColor clearColor]];
    
    [self.pageSlider setMinimumTrackTintColor:[UIColor clearColor]];
    [self.pageSlider setThumbImage:[UIImage imageNamed:@"slider-btn@2x.png"] forState:UIControlStateNormal];
    
    self.fontSliderBar.backgroundColor = [UIColor colorWithRed:111.0/255.0 green:151.0/255.0 blue:164.0/255.0 alpha:1];
    NSString * text = [self.dataSource createPage:self.ChID childId:childID bit:0];
    
    self.originalString = [[NSMutableAttributedString alloc] initWithString:text];
    NSAttributedString * drawingAttrText = [self getAttributedSubStringToFitVisibleRectFromString:self.originalString InView:self.textView ForPageNumber:pageNumber];
    
    self.dataViewController = [[DataViewController alloc] initWithAttributedString:drawingAttrText];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.dataViewController.fontStyle = [self.userDefaults objectForKey:@"FontFamily"];
    self.dataViewController.fontSize = [[self.userDefaults objectForKey:@"FontSize"] intValue];
    self.dataViewController.fontStyleBold = [ NSString stringWithFormat:@"Helvetica-Bold"];
    
    NSArray *viewControllers = [NSArray arrayWithObject:self.dataViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.view.frame = self.view.frame;
    //  self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    self.searchCont=[[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    
    
    
    //  [self performSelector:@selector(removeSplash:) withObject:nil afterDelay:0.5];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"  Back" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //    item.image = [UIImage imageNamed:@"back.png"];
    self.navigationItem.leftBarButtonItem = item;
    
    //    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
    //    self.navigationItem.rightBarButtonItem = item;
    
    [self.view bringSubviewToFront:self.pageNo];
    [self.view bringSubviewToFront:self.chapterNo];
    [self.view bringSubviewToFront:self.myToolbar];
    
    [self.view bringSubviewToFront:self.fontSliderBar];
    //    self.fontSliderBar.hidden = YES;
    
    //here 92 are the chapters and 2 is for prefix and introduction
    chapterPrefix = 2;
    totalChapters = 88+ chapterPrefix;
    CGRect  bounds = [[UIScreen mainScreen]bounds];
    if(bounds.size.height==480){
        NSLog(@"iphone 4");
    }
    else if(bounds.size.height==568)
    {
        NSLog(@"iphone 5");
    }
        
    self.totalPages = [self.dataSource getBookPageNo:kBookID];
    if (self.totalPages == 0) {
        //updating page numbers in chapter and book table
        [MBProgressHUD showHUDAddedTo:self.view withText:@"Configuring.." animated:YES];
        [self calculateBookPages];
        
    }
    else{
        self.lastChapterPages = self.totalPages-[self.dataSource maxId:@"Chapter" field:@"page_no"];
        self.pageSlider.minimumValue = 1;
        self.pageSlider.maximumValue = self.totalPages;// - self.lastChapterPages;
    }
    pageNumber=1;
    self.fontSliderBar.hidden = YES;
    [super viewDidLoad];
    
    // [self.navigationItem setLeftBarButtonItem:nil];
    
    self.notesController = [[NotesViewController alloc]initWithNibName:@"NotesViewController" bundle:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kChapterSelectedNotification object:nil];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:kChapterSelectedNotification];
}

- (void) backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSettings:(id)sender {
    BAMSettings * settings = [[BAMSettings alloc]initWithTitle:@"Settings" propertyListNamed:@"Root"];
    settings.delegate = self;//(id) self.dataViewController;
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:settings];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}
-(void) calculateBookPages
{
    @try {
        //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            pno = 0;
            int prevChPageno=1;
            int currentCh =0;
            for (int i=1; i<=totalChapters; i++) {
                currentCh = [self.dataSource currentChapterNo:currentCh];
                [self calculateChapterNo:currentCh];
                
                [self.dataSource setChapterPageNo:currentCh pageNo:prevChPageno];
                prevChPageno = pno+1;
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.dataSource setBookPageNo:kBookID pageNo:pno];
                self.totalPages = pno;//[self.dataSource getBookPageNo:kBookID];
                self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
                self.lastChapterPages = self.totalPages-[self.dataSource maxId:@"Chapter" field:@"page_no"];
                self.pageSlider.minimumValue = 1;
                self.pageSlider.maximumValue = self.totalPages;// - self.lastChapterPages;
            });
        });
    }
    @catch (NSException *exception) {
        UIAlertView * alrt = [[UIAlertView alloc]initWithTitle:exception.description message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alrt show];
    }
    @finally {
        
    }
}
-(int) calculateChapterNo: (int)cid
{
    [self.dataSource tbName:@"paragraph"];
    NSString *text=[self.dataSource createPage:cid childId:-1 bit:0];
    
    
    NSAttributedString * drawingText;
    
    NSRange range;
    
    
    self.chTitle=[self.dataSource chapterTitle:cid];
    //appending chapter title with first para
    NSString * test = self.chTitle;
    if (test ==nil) {
        NSLog(@"no such chapter");
    }
    else{
        text =[NSString stringWithFormat:@"%@%@",self.chTitle,text];
        NSRange titleRange=[text rangeOfString:self.chTitle];
        self.originalString =  [self.dataViewController applyStyle:text titleRange:titleRange];
        NSAttributedString *or2 =  self.originalString;
        
        while(self.originalString.length!=0) {
            pno++;
            drawingText = [self getAttributedSubStringToFitVisibleRectFromString:self.originalString InView:self.dataViewController.drawingTextView ForPageNumber:pageNumber];
            range=[or2.string rangeOfString:drawingText.string];
            NSRange r=[self.originalString.string rangeOfString:[self.originalString.string substringFromIndex:range.length] ];
            if (r.location!= NSNotFound)
                self.originalString = [or2 attributedSubstringFromRange:r];
            else break;
        }
    }
    return pno;
}

- (void) chapterSelectdAction:(NSNotification*)notif{
    NSNumber * ch_id = notif.object;
    self.ChID=[ch_id intValue];
    [self getChapter:self.ChID];
    
    NSMutableAttributedString * drawingAttrText = [self.pages objectAtIndex:self.top];
    DataViewController* dataViewController = (DataViewController*)[self.pageViewController.viewControllers objectAtIndex:0];
    
    [dataViewController.drawingTextView setAttributedText:drawingAttrText];
    
    
    
    //    [dataViewController.drawingTextView setAttributedString:drawingAttrText];
    pageNumber=[self.dataSource getChapterPageNo:self.ChID];
    self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
    self.chapterNo.text=[NSString stringWithFormat:@"%@", self.chTitle];
    
    [self.view setNeedsDisplay];
    
    NSLog(@"Selected Chapter ID is %@", ch_id);
}
- (void) gotoSavedChapter:(int)chapterID top:(int)chTop{
    
    self.ChID= chapterID;
    [self getChapter:self.ChID];
    self.top = chTop;
    NSMutableAttributedString * drawingAttrText = [self.pages objectAtIndex:self.top];
    DataViewController* dataViewController = (DataViewController*)[self.pageViewController.viewControllers objectAtIndex:0];
    
    [dataViewController.drawingTextView setAttributedText:drawingAttrText];
    
    //    [dataViewController.drawingTextView setAttributedString:drawingAttrText];
    pageNumber=[self.dataSource getChapterPageNo:self.ChID];
    self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
    self.chapterNo.text=[NSString stringWithFormat:@"%@", self.chTitle];
    
    [self.view setNeedsDisplay];
    
}
- (void) searchSelectedAction:(NSNotification*)notif{
    Chapter * searchCh = notif.object;
    [self getChapter:searchCh.chID];
    self.ChID = searchCh.chID ;
    NSRange searchRange,summaryRange ;
    
    for (int i=0; i<self.pages.count; i++) {
        searchRange =[[[self.pages objectAtIndex:i]string] rangeOfString:searchCh.searchText];
//        summaryRange =[[[self.pages objectAtIndex:i]string] rangeOfString:searchCh.paraSummary];         
       
        if (searchRange.location != NSNotFound) {
            UIFont * headingFont = [UIFont fontWithName:kHeadingFontName size:self.dataViewController.fontSize+2];
            [[self.pages objectAtIndex:i] addAttribute:NSFontAttributeName value:headingFont range:searchRange];
            //  [self.dataViewController.drawingTextView setSelectedRange:range];
            break;
        }
        self.top++;
    }
    
    NSMutableAttributedString * drawingAttrText = [self.pages objectAtIndex:self.top];
    DataViewController* dataViewController = (DataViewController*)[self.pageViewController.viewControllers objectAtIndex:0];
    
    [dataViewController.drawingTextView setAttributedText:drawingAttrText];
    //    [dataViewController.drawingTextView setAttributedString:drawingAttrText];
    pageNumber=[self.dataSource getChapterPageNo:self.ChID];
    self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
    self.chapterNo.text=[NSString stringWithFormat:@"%@", self.chTitle];
    //
    [self.view setNeedsDisplay];
    
}

-(void) getChapter: (int)cid
{
    @try {
        
        
        // below funtion will return whole chapter
        NSString *text=[self.dataSource createPage:cid childId:-1 bit:0];
        NSAttributedString * drawingText;
        
        NSRange range,chRange;
        
        self.pages=[[NSMutableArray alloc]init];
        self.top=0;
        //this function will return chapter titile
        self.chTitle=[self.dataSource chapterTitle:cid];
        self.currentChID = 1;
        for (int c = cid-5; c<cid+5; c++) {
            chRange = [self.chTitle rangeOfString:[NSString stringWithFormat:@"%i. ",c]];
            if (chRange.location!= NSNotFound) {
                self.currentChID = c;
                break;
            }
        }
        
        //appending chapter title with first para
        
        text =[NSString stringWithFormat:@"%@%@",self.chTitle,text];
        NSRange titleRange=[text rangeOfString:self.chTitle];
        // this function will apply  attributes on string and return attributed string
        self.originalString =  [self.dataViewController applyStyle:text titleRange:titleRange];
        NSAttributedString *or2 =  self.originalString;
        // this loop will make pages from current chapter attributed string
        while(self.originalString.length!=0) {
            //this function will return text for a page according to screen size
            drawingText = [self getAttributedSubStringToFitVisibleRectFromString:self.originalString InView:self.dataViewController.drawingTextView  ForPageNumber:pageNumber];
            range=[or2.string rangeOfString:drawingText.string];
            NSRange r=[or2.string rangeOfString:[self.originalString.string substringFromIndex:range.length] ];
            [self.pages addObject: [or2 attributedSubstringFromRange:range]];
            if (r.location!= NSNotFound){
                
                self.originalString = [or2 attributedSubstringFromRange:r];
            }
            else break;
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"Recieved Memory Warning in CORE VIEW CONTROLLER");
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UIPageViewControllerDelegate Method
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed!=YES && self.finishAnimation == YES) {
        if(self.top==self.pages.count)// && self.ChID<5)
        {
            self.top=0;
            self.ChID++;
        }
        else
            self.top++;
        pageNumber++;
    }
    if (completed!=YES && self.finishAnimation == NO) {
        NSLog(@"Before next CONTROLlER top  = %i",self.top);
        if(self.top==0)
        {
            --self.ChID;
            [self getChapter:self.ChID];
            self.top=self.pages.count-1;
        }
        
        else
            self.top--;
        pageNumber--;
    }
    
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(![self.navigationController isNavigationBarHidden])
        [self hideShowNavBar:nil];
    DataViewController *dataViewController=nil;
    
    if(self.top>0){
        self.finishAnimation = YES;
        pageNumber--;
        self.top--;
        
        NSMutableAttributedString * drawingAttrText =  [self.pages objectAtIndex:self.top];//[[NSMutableAttributedString alloc] initWithString:[self.pages objectAtIndex:self.top]];
        dataViewController = [[DataViewController alloc] initWithAttributedString:drawingAttrText];
        
    }
    else if(self.top==0 && self.ChID>1)
    {
        self.finishAnimation = YES;
        pageNumber--;
        self.ChID = [self.dataSource prevChapterNo:self.ChID];
        [self getChapter:self.ChID];
        self.top=self.pages.count-1;
        NSMutableAttributedString * drawingAttrText =  [self.pages objectAtIndex:self.top];
        dataViewController = [[DataViewController alloc] initWithAttributedString:drawingAttrText];
        self.chapterNo.text=[NSString stringWithFormat:@"%@", self.chTitle];
        [self.userDefaults setInteger:self.currentChID + chapterPrefix - 1 forKey:@"CurrentChapter"];
        
    }
    self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
    
    //    [self setDataViewController:dataViewController];
    return dataViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(![self.navigationController isNavigationBarHidden])
        [self hideShowNavBar:nil];
    DataViewController* dataViewController=nil;
    
    if (self.top<self.pages.count-1)
    {
        self.finishAnimation = NO;
        pageNumber++;
        self.top++;
        NSMutableAttributedString * drawingAttrText =  [self.pages objectAtIndex:self.top];
        dataViewController = [[DataViewController alloc] initWithAttributedString:drawingAttrText];
        self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
    }
    else //if(self.ChID<totalChapters)
    {
        self.finishAnimation = NO;
        
        // mark previous chapter as read
        [self.dataSource markChapterAsRead:self.ChID isRead:1];
        [self.userDefaults setBool:true forKey:@"isRead"];
        
        int temp = self.ChID;
        self.ChID = [self.dataSource currentChapterNo:self.ChID];
        
        if(self.ChID!=temp){ //to exclude last chapter
            pageNumber++;
            [self getChapter:self.ChID];
            NSMutableAttributedString * drawingAttrText =  [self.pages objectAtIndex:self.top];
            dataViewController = [[DataViewController alloc] initWithAttributedString:drawingAttrText];
            self.chapterNo.text=[NSString stringWithFormat:@"%@", self.chTitle];
            self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
            [self.userDefaults setInteger:self.currentChID+chapterPrefix - 1 forKey:@"CurrentChapter"];
        }
    }
    //    [self setDataViewController:dataViewController];
    return dataViewController;
}

//- (NSString*) getSubStringToFitVisibleRectFromString:(NSString*)text InView:(UIView*)textContainingView ForPageNumber:(int)page{
//
//    CGRect bounds = [[UIScreen mainScreen] bounds];
//    CGRect textFrame = CGRectInset(bounds, 20, 40);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, textFrame );
//    NSAttributedString * atStr = [[NSAttributedString alloc] initWithString:text attributes:self.textView.attributes];
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) atStr);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
//
//
//    NSString * rangeString = [NSString stringWithFormat:@"{%ld,%ld}",frameRange.location,frameRange.length];
//    NSRange range = NSRangeFromString(rangeString);
//    NSString * subString = [text substringWithRange:range];
//    CFRelease(frame);
//    CFRelease(path);
//    return subString;
//}

- (NSAttributedString *) getAttributedSubStringToFitVisibleRectFromString:(NSAttributedString*)text InView:(UIView*)textContainingView ForPageNumber:(int)page{
    
    CGRect bounds = [[UIScreen mainScreen] bounds];//textContainingView.bounds;//
    CGRect textFrame = CGRectInset(bounds, 20, 40);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) text);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    
    
    //NSString * rangeString = [NSString stringWithFormat:@"{%ld,%ld}",frameRange.location,frameRange.length];
    NSRange range = NSMakeRange(frameRange.location, frameRange.length);
    NSAttributedString * subString = [text attributedSubstringFromRange:range];
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    return subString;
}

-(IBAction)removeSplash:(id)sender
{
    [self.splashView removeFromSuperview];
}

-(IBAction)showSearchBar:(id)sender
{
    //    SearchViewController *searchCont=[[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController *searchNav=[[UINavigationController alloc]initWithRootViewController:self.searchCont];
    [searchNav.navigationBar setBarStyle:UIBarStyleBlack];
    [self presentViewController:searchNav animated:YES completion:nil];
    
}
-(IBAction)showContent:(id)sender
{
    
    //  TOCViewController *cont=[[TOCViewController alloc]initWithNibName:@"TOCViewController" bundle:nil];
    // ViewController *cont=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    
    //    ViewController * cont = [self.navigationController.viewControllers objectAtIndex:0];
    //    cont.title=@"Table of Content";
    //    UINavigationController *tocNav=[[UINavigationController alloc]initWithRootViewController:cont];
    //    cont.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    //   // tocNav.navigationBar.tintColor =[UIColor brownColor];
    //   // [tocNav.navigationBar setBarStyle:UIBarStyleBlack];
    //    [self presentViewController:cont animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelButtonTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)showFontBar:(id)sender
{
    @try {
        self.fontSliderBar.hidden = !self.fontSliderBar.isHidden;
        
        if(pageNumber>0){
            self.pageSlider.value = pageNumber;
        }
        else
            self.pageSlider.value = 1;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //    [self.view addSubview:self.tempView];
    //    self.tempView.center = self.view.center;
    //    self.tempView.hidden = !self.tempView.isHidden;
    //    [self.view bringSubviewToFront:self.tempView];
}

- (IBAction) notesButtonTapped:(id)sender{
    [self.notesController setChapterID:self.ChID];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:self.notesController];
    [self presentModalViewController:nav animated:YES];
    //    nav.view.frame = CGRectMake(0, 480, 320, 240);
    //    [self showViewWithAnimation:nav.view];
}
-(IBAction)hideShowNavBar:(id)sender
{
    if (self.navigationController.navigationBar.hidden == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
            self.myToolbar.alpha = 0.0;
        } completion:^(BOOL finishes){
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.myToolbar setHidden:YES];
        }];
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.myToolbar setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationController.navigationBar.alpha = 1.0;
            self.myToolbar.alpha = 1.0;
        } completion:^(BOOL finishes){
            
        }];
    }
    self.fontSliderBar.hidden = YES;//!self.fontSliderBar.isHidden;
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)fontSlider:(id)sender {
    
    @try {
        NYSliderPopover *slider= (NYSliderPopover *)sender;
        int value= (int) roundf(slider.value);
        //    self.currentChID =1;
        //    NSRange chRange;
        //    for (int c = self.ChID-5; c<self.ChID+5; c++) {
        //        chRange = [self.chTitle rangeOfString:[NSString stringWithFormat:@"%i. ",c]];
        //        if (chRange.location!= NSNotFound) {
        //            self.currentChID = c;
        //            break;
        //        }
        //    }
        //
        slider.popover.textLabel.text = [NSString stringWithFormat:@"CH : %i \nPage %i",self.currentChID,value];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}

#pragma mark - NYSliderPopoverDelegate
- (void)sliderDidEndSliding{
    
    int value= (int) roundf(self.pageSlider.value);
    NSMutableArray *chapterDetail;
    
    // NSLog(@"vlaue =%d and last page noss %d", value,self.lastChapterPages);
    if(value>=self.totalPages-self.lastChapterPages){
        value =value-self.lastChapterPages;
        chapterDetail = [self.dataSource getChapterID:0 uperBound:value isLast:1];
    }
    else
        chapterDetail = [self.dataSource getChapterID:0 uperBound:value isLast:0];
    self.ChID =  [[chapterDetail objectAtIndex:0] intValue ];
    //   NSLog(@"selected chapter =%i",self.ChID );
    [self getChapter:self.ChID];
    self.top = value - [[chapterDetail objectAtIndex:1] intValue];
    while(self.top >=self.pages.count)
        self.top--;
    //   NSLog(@"slider did end sliding.");
    pageNumber=[self.dataSource getChapterPageNo:self.ChID];
    self.pageNo.text=[NSString stringWithFormat:@"%i of %i",pageNumber,self.totalPages];
    self.chapterNo.text=[NSString stringWithFormat:@"%@", self.chTitle];
    
    DataViewController * dc = [self.pageViewController.viewControllers objectAtIndex:0];
    [dc.drawingTextView setAttributedText:[self.pages objectAtIndex:self.top]];
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if(gestureRecognizer.view == self.myToolbar)
//        return NO;
//    return YES;
//}
- (void)settingsDidChangeValueForKey:(NSString *)key{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Its working" message:@"Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
    
    @try {
        
        NSUserDefaults *settDef = [NSUserDefaults standardUserDefaults];
        DataViewController * dataCont = nil;
        if(self.pageViewController.viewControllers.count > 0)
            dataCont = [self.pageViewController.viewControllers objectAtIndex:0];
        
        if ([key isEqualToString:@"FontColor"]){
            NSString * color = [settDef stringForKey:key];
            
            if([color isEqualToString:@"White"]){
                self.view.backgroundColor = [UIColor blackColor];
                dataCont.view.backgroundColor = [UIColor blackColor];
                dataCont.drawingTextView.backgroundColor = [UIColor blackColor];
                dataCont.drawingTextView.textColor = [UIColor whiteColor];
            }
            else{
                self.view.backgroundColor = [UIColor whiteColor];
                dataCont.view.backgroundColor = [UIColor whiteColor];
                dataCont.drawingTextView.backgroundColor = [UIColor whiteColor];
                dataCont.drawingTextView.textColor = [UIColor blackColor];
            }
            return;
        }
        
        if ([key isEqualToString:@"FontSize"]) {
            dataCont.fontSize = [[settDef objectForKey:key] intValue];
            dataCont.drawingTextView.font = [UIFont fontWithName:[settDef objectForKey:@"FontFamily"] size:[[settDef objectForKey:key]intValue]];
            [dataCont.drawingTextView setNeedsDisplay];
        }
        else if([key isEqualToString:@"FontFamily"]){
            dataCont.fontStyle = [settDef stringForKey:key];
            dataCont.fontStyleBold = @"Helvetica-Bold";
            dataCont.drawingTextView.font = [UIFont fontWithName:[settDef objectForKey:key] size:[settDef floatForKey:@"FontSize"]];
            [dataCont.drawingTextView setNeedsDisplay];
        }
        
        /*
         // store current page number and recalculate pages and assing page
         
         NSString * currentPageText = [[self.pages objectAtIndex:self.top] string];
         currentPageText = [currentPageText substringWithRange:NSMakeRange(0, 10)];
         //        [self calculateBookPages];
         [self getChapter:self.ChID];
         NSRange range;
         
         for (int i=0; i<self.pages.count; i++) {
         NSString *txt =[[self.pages objectAtIndex:i]string];
         range =[txt rangeOfString:currentPageText];
         if (range.location != NSNotFound) {
         NSLog(@"got text range");
         break;
         }
         self.top++;
         }
         
         if(self.top >= self.pages.count)
         self.top = self.pages.count/2;
         
         NSLog(@"New Text: %@",[self.pages objectAtIndex:self.top]);
         */
    }
    @catch (NSException *exception) {
        NSLog(@"In setting did Change funciton  %@",exception);
    }
    @finally {
        
    }
}

@end