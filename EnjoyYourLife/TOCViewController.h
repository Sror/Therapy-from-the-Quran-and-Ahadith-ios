//
//  TOCViewController.h
//  TestCoreText
//
//  Created by ahadnawaz on 11/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "CustomCellViewController.h"

@interface TOCViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@property (strong,nonatomic) NSMutableArray *searchContents;
@property (strong,nonatomic) NSMutableArray *contents;
@property (strong,nonatomic) DataSource *dataSource;
@property (strong, nonatomic)   NSUserDefaults *userDefault ;
@property (strong,nonatomic) NSMutableArray *readChapters;
//@property (weak, nonatomic) IBOutlet CustomCellViewController * customCell;
@property int k;
- (void)favoriteButtonPressed:(id)sender;
@end
