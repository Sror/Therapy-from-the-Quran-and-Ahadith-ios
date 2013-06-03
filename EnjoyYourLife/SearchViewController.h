//
//  SearchViewController.h
//  EnjoyYourLife
//
//  Created by ahadnawaz on 22/03/2013.
//  Copyright (c) 2013 D-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property DataSource *dataSource;
@property (strong,nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@end