//
//  coreViewController.h
//  TestCoreText
//
//  Created by ahadnawaz on 08/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "DataViewController.h"
#import "Stack.h"
#import <sqlite3.h>
#import "EGODatabase.h"
#import "NotesViewController.h"
#import "NYSliderPopover.h"
#import "SearchViewController.h"
#import "CustomTextView.h"

@class ViewController;
@class JLTextView;
@interface coreViewController : UIViewController <UIScrollViewDelegate,UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIGestureRecognizerDelegate, NYSliderPopoverDelegate,BAMSettingsDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *current_page;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;
@property DataSource *dataSource;
@property BAMSettings *bmSettings;
@property (strong,nonatomic)  UIImageView *splashView;
@property (nonatomic, weak) IBOutlet CustomTextView *textView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *pageNo;
@property (strong,nonatomic) NSMutableArray *allChaptersNo;
@property (strong, nonatomic) IBOutlet UILabel *chapterNo;
@property (strong, nonatomic) IBOutlet UIToolbar *fontSliderBar;
@property DataViewController *dataViewController;
@property (weak, nonatomic) IBOutlet NYSliderPopover *pageSlider;
@property (strong,nonatomic) SearchViewController *searchCont;
- (IBAction)fontSlider:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *accessoryButton;

@property (weak, nonatomic) IBOutlet UIView *tempView;

@property (strong, nonatomic) NSMutableAttributedString * originalString;
@property (strong, nonatomic) NSMutableAttributedString * remainingString;
@property (strong,nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) NSString * substring, *chTitle;
@property (strong, nonatomic) NotesViewController * notesController;
@property (strong,nonatomic) NSUserDefaults *userDefaults ;
//@property (strong, nonatomic) NSString *prevSubstring;
@property   int top,ChID,totalPages;//,fontSize;
//@property (strong, nonatomic) NSString *fontStyle;
@property bool finishAnimation;
@property int lastChapterPages;
@property int currentChID;
//@property   NSRange prevTextRange;

@property (strong, nonatomic)  UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) HsuStack * previousPagesStack;
@property (strong, nonatomic) HsuStack * rangeStack;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) NSArray *gestureArray;
@property (weak, nonatomic) IBOutlet UIView *containerView;
-(IBAction)hideShowNavBar:(id)sender;
- (void)settingsDidChangeValueForKey:(NSString *)key;
- (NSString*) getSubstringForPageNumber:(int)page;
//- (NSString*) getSubStringToFitVisibleRectFromString:(NSString*)text InView:(UIView*)textContainingView ForPageNumber:(int)page;
- (NSAttributedString *) getAttributedSubStringToFitVisibleRectFromString:(NSAttributedString*)text InView:(UIView*)textContainingView ;
-(void) calculateBookPages;
-(int) calculateChapterNo: (int)cid;
- (void) gotoSavedChapter:(int)chapterID top:(int)chTop;


-(void) getAllChapterNo;
-(int) getChapterAtPage:(int)currentpgno;

//-(NSMutableAttributedString *)applyStyle:(NSString *)str;
//@property DataViewController *dataViewController;
//- (NSString*) getRemainingStringFromString:(NSString*)text;
//- (NSString*) getBeforeSubstringFromString:(NSString*)text ForPageNumber:(int)page;


// Bottom Bar Action Methods


@end
