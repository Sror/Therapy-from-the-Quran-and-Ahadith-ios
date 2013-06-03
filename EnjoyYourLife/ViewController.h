//
//  ViewController.h
//  EnjoyYourLife
//
//  Created by RAC on 2/19/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAMSettings.h"
#import "DataSource.h"
#import <sqlite3.h>
#import "coreViewController.h"
#import "CustomCellViewController.h"

@class Chapter;
@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, BAMSettingsDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSArray * searchResults;
@property (strong,nonatomic) DataSource *dbSource;
@property (strong,nonatomic) coreViewController * coreController;
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureRecognizer;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *coverPageImageView;

@property (strong,nonatomic) NSMutableArray *readChapters;
  @property int k;
@property bool showCoverPage;
@property (nonatomic, retain) NSIndexPath * currentIndexPath;
@property (strong, nonatomic) IBOutlet UIButton *accessoryButton;

- (IBAction)goToNextChapter:(id)sender;
- (IBAction)goToPreviousChapter:(id)sender;

- (IBAction)goToFirstChapter:(id)sender;
- (IBAction)goToLastChapter:(id)sender;
-(void) hideCoverPage;
- (IBAction)showSettings:(id)sender;

@end
