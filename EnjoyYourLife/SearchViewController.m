//
//  SearchViewController.m
//  EnjoyYourLife
//
//  Created by ahadnawaz on 22/03/2013.
//  Copyright (c) 2013 D-Tech. All rights reserved.
//

#import "SearchViewController.h"
#import "coreViewController.h";

@interface SearchViewController ()

@end

@implementation SearchViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.dataSource=[[DataSource alloc]init];
//        [self.dataSource  dbConnection:@"Dtech"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.searchDisplayController.searchBar.tintColor=[UIColor brownColor];
    [self.searchDisplayController.searchBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title=@"Search";
    self.searchDisplayController.searchBar.placeholder=@"Word Search From Book";
//    [self.searchDisplayController.searchBar becomeFirstResponder];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //    item.image = [UIImage imageNamed:@"back.png"];
    self.navigationItem.leftBarButtonItem = item;
    
    self.searchArray=[[NSMutableArray alloc]init];
    [self.searchDisplayController.searchResultsTableView setRowHeight:80.0];
    [self.searchDisplayController.searchBar becomeFirstResponder];
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
     // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // Return the number of rows in the section.
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text=[[self.searchArray objectAtIndex:indexPath.row] chapterTitle];
        cell.detailTextLabel.text= [[self.searchArray objectAtIndex:indexPath.row] paraSummary] ;
        cell.detailTextLabel.numberOfLines=3;

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
         [[NSNotificationCenter defaultCenter]postNotificationName:kSearchSelectedNotification object:[self.searchArray objectAtIndex:indexPath.row]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)cancelSearch
{
    [self dismissModalViewControllerAnimated:YES];
}
  

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchArray removeAllObjects];
    self.searchArray= [self.dataSource search:self.searchDisplayController.searchBar.text];
    [self.searchDisplayController.searchResultsTableView reloadData];
   
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    [self.searchArray removeAllObjects];
//    return YES;
//}
- (void)viewDidUnload {
     [self setMySearchBar:nil];
    [super viewDidUnload];
}
@end
