//
//  TOCViewController.m
//  TestCoreText
//
//  Created by ahadnawaz on 11/03/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import "TOCViewController.h"
#import "coreViewController.h"

@interface TOCViewController ()

@end

@implementation TOCViewController
 static BOOL nibsRegistered ;
 

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
        
    return self;
}
 - (void)viewDidLoad
{
    [super viewDidLoad];
    nibsRegistered = NO;
    self.myTable.rowHeight = 50;
    //initialize db
    self.dataSource =[[DataSource alloc]init];
//    [self.dataSource dbConnection:@"DTech"];
    [self.dataSource tbName:@"Chapter"];
    
    self.readChapters = [[NSMutableArray alloc] init];
    self.userDefault = [NSUserDefaults standardUserDefaults];
     self.readChapters = [self.userDefault stringArrayForKey:@"readChapters"];
    self.contents=[self.dataSource TOC:0];
    self.searchContents=[[NSMutableArray alloc]init];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cencelSearch)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return self.searchContents.count;
    }
    else
     return self.contents.count;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
     
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CustomCellViewController" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
       nibsRegistered = YES;
        self.k=0;
        if (self.readChapters.count==0) {
            self.readChapters = nil;
            [self.userDefault setValue:nil forKey:@"readChapters"];
            [self.userDefault synchronize];
        }
    }
     
 
    CustomCellViewController *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
     [cell.favBtn addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
     [cell.favBtn setTag:indexPath.row];
     cell.label.text = [[self.contents objectAtIndex:indexPath.row] chapterTitle];
      if (([[self.readChapters objectAtIndex:self.k] intValue] == indexPath.row) && (self.k<self.readChapters.count-1) && self.readChapters.count!=0)
      {
        [cell.favBtn setSelected:NO];
        self.k++;
      //  NSLog(@"read chapter count == %i",self.readChapters.count);
     }
    else if (([[self.readChapters objectAtIndex:self.k] intValue] == indexPath.row) && (self.k==self.readChapters.count-1))
        {
            [cell.favBtn setSelected:NO];
        }
     else{
        [cell.favBtn setSelected:YES];
    }
    
 
     return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//- (NSString *) getChapterIDForChapterName:(NSString*)name{
//    return @"1";
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int ch_index;
     if (tableView == self.searchDisplayController.searchResultsTableView) {
           ch_index=[[self.searchContents objectAtIndex:indexPath.row]chID];
    }
    else
       ch_index=[[self.contents objectAtIndex:indexPath.row]chID];
    NSNumber *ch_id=[NSNumber numberWithInt:ch_index];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kChapterSelectedNotification object:ch_id];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Searching

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"chapterTitle contains[cd] %@",
                                    searchText];
    
    self.searchContents = [self.contents filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                                        selectedScopeButtonIndex]]];
    
    return YES;
}

 -(void)cencelSearch
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)favoriteButtonPressed:(id)sender{
    UIButton * btn = (UIButton*)sender;
  //   NSLog(@"%d",btn.tag);
    if (btn.selected) {
        btn.selected = NO;
         self.readChapters = [[NSMutableArray alloc]initWithArray:self.readChapters];
        [self.readChapters addObject:[NSString stringWithFormat: @"%i",btn.tag]];
        [self sortArray];
        [self.userDefault setValue:self.readChapters forKey:@"readChapters"];
  //      NSLog(@"After in Fav btn read chapter count == %i",self.readChapters.count);
     [self.userDefault synchronize];
//        [diaryDSource isFav:0 rowId:btn.tag];
        
    }
    else{
         self.readChapters = [[NSMutableArray alloc]initWithArray:self.readChapters];
        if( [self.readChapters containsObject:[NSString stringWithFormat:@"%i",btn.tag]])
        {
            int index = [self.readChapters indexOfObject:[NSString stringWithFormat:@"%i",btn.tag]];
            [self.readChapters removeObjectAtIndex:index];
            [self sortArray];
            
            btn.selected = YES;
              [self.userDefault setValue:self.readChapters forKey:@"readChapters"];
            [self.userDefault synchronize];
        

        }
              
//        [diaryDSource isFav:1 rowId:btn.tag];
    }
    
}
-(void) sortArray
{
    NSArray *sortedArray = [self.readChapters sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
            
        }
        
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    self.readChapters = [[NSMutableArray alloc] initWithArray:sortedArray];
//    for (int i=0; i<self.readChapters.count; i++) {
//        NSLog(@"%i ) %@ \n",i,[self.readChapters objectAtIndex:i]);
//    }

}
@end
