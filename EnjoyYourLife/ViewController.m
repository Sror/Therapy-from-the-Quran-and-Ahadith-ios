//
//  ViewController.m
//  EnjoyYourLife
//
//  Created by RAC on 2/19/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import "ViewController.h"
#import "BAMSettings.h"
#import "DetailViewController.h"
#import "Chapter.h"

@interface ViewController ()

@end

@implementation ViewController
static bool nibsRegistered;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal ];
        btn.frame = CGRectMake(0, 0, 50, 30);
        [btn addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
          UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
         self.navigationItem.rightBarButtonItem = item;
        
//        UIBarButtonItem *contents=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-chapters.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
//        [contents setTintColor:[UIColor colorWithRed:111.0/255.0 green:151.0/255.0 blue:164.0/255.0 alpha:1]];
//        self.navigationItem.rightBarButtonItem =contents;
//        
    }
    return self;
}
 
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    
    // Called when user finish reading a chapter and returns to Table of Contents, that chapter will be marked as read
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isRead"]==true){
        self.dataSource = [self.dbSource TOC:0];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isRead"];
       
    }
     int current = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentChapter"];
        [self.myTableView reloadData];
        [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:current inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    nibsRegistered = NO;

    self.myTableView.rowHeight = 50;
    self.searchDisplayController.searchResultsTableView.rowHeight = 50;

    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    //self.title = @"";
    self.dbSource =[DataSource sharedInstance];
     [self.dbSource tbName:@"Chapter"];
    
    self.dataSource = [self.dbSource TOC:0];
    self.coreController = [[coreViewController alloc]initWithNibName:@"coreViewController" bundle:nil];
    self.navigationItem.title = @"Therapy from Quran and Ahadith";
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:self.navigationController.navigationBar.frame];
//    [titleLabel setText:@"Enjoy Your Life"];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.navigationItem setTitleView:titleLabel];
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

-(void) hideCoverPage
{
 
    if(self.showCoverPage ==YES){
         [self.coverPageImageView  setHidden:NO];
        [UIView animateWithDuration:4.0 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.coverPageImageView  setHidden:NO];
            self.coverPageImageView.alpha = 0;
            self.coverPageImageView.transform = CGAffineTransformIdentity;//CGAffineTransformMakeRotation(2);

            
        } completion:^(BOOL finished){
            [self.mySearchBar setBarStyle:UIBarStyleBlack];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.coverPageImageView removeFromSuperview];
        }];
    }

}
- (void) handleTap:(UITapGestureRecognizer*)gestrue{
//    [UIView beginAnimations:@"TOC"  context:nil];
//        [UIView setAnimationDuration:1];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.coverPageImageView cache:YES];
////    CGRect frame = self.coverPageImageView.frame;
//   // self.coverPageImageView.frame = CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height);
//    [UIView commitAnimations];
//    [self.coverPageImageView performSelector:@selector(setHidden:) withObject:nil afterDelay:1];
       [UIView animateWithDuration:0.5 animations:^{
        //self.coverPageImageView.alpha = 0.0;
           
       //    self.coverPageImageView.transform = CGAffineTransformMakeRotation(2);
        CGRect frame = self.coverPageImageView.frame;
        self.coverPageImageView.frame = CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height);
    } completion:^(BOOL finished){
        [self.coverPageImageView setHidden:YES];
    }];
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//       // CGRect frame = self.coverPageImageView.frame;
//      //  self.coverPageImageView.frame = CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height);
//    }completion:^(BOOL finished) {
    
//    }];
}

- (void) showSettings{
    BAMSettings * settings = [[BAMSettings alloc]initWithTitle:@"Settings" propertyListNamed:@"Root"];
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:settings];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Recieved Memory Warning in ViewController");
    // Dispose of any resources that can be recreated.
}

- (void)showAlert{
    NSUInteger size = [[NSUserDefaults standardUserDefaults]floatForKey:@"FontSize"];
    defaultFontSize = size;
    UIAlertView * alrt = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Font Size is %f",defaultFontSize] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alrt show];
    [self.myTableView reloadData];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.dataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier=@"cellIdentifier";
    static NSString *defaultCellIdentifier=@"defaultCellIdentifier";
    CustomCellViewController *cell;
    UITableViewCell *searchCell;
    
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"CustomCellViewController" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            cell.label.font = [UIFont systemFontOfSize:15];
            cell.label.numberOfLines = 0;
            nibsRegistered = YES;
            self.k=0;
        }
        
        
         cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell.accessoryView = self.accessoryButton;
        [cell.favBtn addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.favBtn setTag:indexPath.row];
    
        if (tableView==self.searchDisplayController.searchResultsTableView) {
            searchCell = [tableView dequeueReusableCellWithIdentifier:defaultCellIdentifier];
            
            if(searchCell == nil)
                searchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellIdentifier];
            
            searchCell.textLabel.text=[[self.searchResults objectAtIndex:indexPath.row] chapterTitle];
            searchCell.textLabel.font = [UIFont fontWithName:@"Arial-Bold" size:16];

            
            
            //            cell.label.text=[[self.searchResults objectAtIndex:indexPath.row] chapterTitle];
                            // [cell.favBtn setTag:[[self.searchResults objectAtIndex:indexPath.row] chID]-1];//indexPath.row];
            
            /*
            if(indexPath.row == 0 || indexPath.row == 1){
                [cell.chapterImageView setImage:nil];
            }
            else{
            
            NSString * imgName = [NSString stringWithFormat:@"top-%d.png",indexPath.row - 1];
            [cell.chapterImageView setImage:[UIImage imageNamed:imgName]];
            }
             */
            return searchCell;
        }
        else{
            Chapter * ch = [self.dataSource objectAtIndex:indexPath.row];
            cell.label.text= ch.chapterTitle ; //stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%i. ",indexPath.row-1] withString:@""];
            
//            [cell.chapterImageView setImage:[UIImage imageNamed:ch.imageName]];
            cell.rowNumber.text = [NSString stringWithFormat:@"%i", ch.chID ];

            //[cell.favBtn setTag:[[self.dataSource objectAtIndex:indexPath.row] chID]-1];
       
            if(ch.isRead == 1){
                [cell.favBtn setSelected:YES];
                [cell.readImageView setImage:[UIImage imageNamed:@"read@2x.png"]];
            }
            else{
                [cell.favBtn setSelected:NO];
                [cell.readImageView setImage:[UIImage imageNamed:@"unread@2x.png"]];
            }
            
            [cell bringSubviewToFront:cell.favBtn];
            /*
            //Highliting read chapters
        if (([[self.readChapters objectAtIndex:self.k] intValue] == indexPath.row) && (self.k<self.readChapters.count-1) && self.readChapters.count!=0)
        {
            [cell.favBtn setSelected:NO];
            self.k++;
            NSLog(@"read chapter count == %i",self.readChapters.count);
        }
        else if (([[self.readChapters objectAtIndex:self.k] intValue] == indexPath.row) && (self.k==self.readChapters.count-1))
        {
            [cell.favBtn setSelected:NO];
        }
        else{
            [cell.favBtn setSelected:YES];
        }
    */
            
            
        }
        
        return cell;
    
//    static NSString * cellIdentifier = @"Cell";
//    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(cell == nil){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.numberOfLines = 0;
//    }
//    
//    // Configure Cell
//    if (tableView==self.searchDisplayController.searchResultsTableView) {
//        cell.textLabel.text=[[self.searchResults objectAtIndex:indexPath.row] chapterTitle];
//    }
//    else
//        cell.textLabel.text=[[self.dataSource objectAtIndex:indexPath.row] chapterTitle];
//    
//    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   __block int ch_index;
    
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            ch_index=[[self.searchResults objectAtIndex:indexPath.row]chID];
        }
        else
            ch_index=[[self.dataSource objectAtIndex:indexPath.row]chID];
        
        NSNumber *ch_id=[NSNumber numberWithInt:ch_index];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:kChapterSelectedNotification object:ch_id];
            [self.coreController setChID:ch_id.intValue];
            [self.navigationController pushViewController:self.coreController animated:YES];
        });
    });
    
  
    

    // [self.coreController.navigationController.navigationItem setLeftBarButtonItem:nil];
   // [self.coreController.navigationController.navigationItem setBackBarButtonItem:nil];

//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - Settings
- (void)settingsDidChangeValueForKey:(NSString *)key{
    //[self showAlert];
    [self.navigationController popViewControllerAnimated:NO];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Searching

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"chapterTitle contains[cd] %@",
                                    searchText];
    nibsRegistered = NO;
    self.k=0;
    self.searchResults = [self.dataSource filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}


#pragma mark - Chapter Navigation



- (IBAction)goToNextChapter:(id)sender {
    
    if(self.dataSource.count == 0)
        return;
    NSIndexPath * index = [self.myTableView indexPathForSelectedRow];
    if(index.row+1 < self.dataSource.count)
        self.currentIndexPath = [NSIndexPath indexPathForRow:index.row+1 inSection:index.section];
    [self.myTableView selectRowAtIndexPath:self.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)goToPreviousChapter:(id)sender {
    if(self.dataSource.count == 0)
        return;
    NSIndexPath * index = [self.myTableView indexPathForSelectedRow];
    if(index.row-1 >= 0)
        self.currentIndexPath = [NSIndexPath indexPathForRow:index.row-1 inSection:index.section];
    [self.myTableView selectRowAtIndexPath:self.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)goToFirstChapter:(id)sender {
    if(self.dataSource.count == 0)
        return;
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    self.currentIndexPath = [self.myTableView indexPathForSelectedRow];
}

- (IBAction)goToLastChapter:(id)sender {
    if(self.dataSource.count == 0)
        return;
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    self.currentIndexPath = [self.myTableView indexPathForSelectedRow];    
}
- (IBAction)favoriteButtonPressed:(id)sender{
    UIButton * btn = (UIButton*)sender;
    Chapter * chptr = [self.dataSource objectAtIndex:btn.tag];
    CustomCellViewController * cell = (CustomCellViewController*)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    if(btn.selected){
        btn.selected = NO;
        [cell.readImageView setImage:[UIImage imageNamed:@"unread@2x.png"]];
        [[DataSource sharedInstance] markChapterAsRead:chptr.chID isRead:0];
        chptr.isRead = 0;
    }
    else{
        btn.selected = YES;
        [cell.readImageView setImage:[UIImage imageNamed:@"read@2x.png"]];        
        [[DataSource sharedInstance] markChapterAsRead:chptr.chID isRead:1];
        chptr.isRead = 1;
    }
    [self.dataSource replaceObjectAtIndex:btn.tag withObject:chptr];
    
    /*
    UIButton * btn = (UIButton*)sender;
    NSLog(@"%d",btn.tag);
    if (btn.selected) {
        btn.selected = NO;
        self.readChapters = [[NSMutableArray alloc]initWithArray:self.readChapters];
        [self.readChapters addObject:[NSString stringWithFormat: @"%i",btn.tag]];
        [self sortArray];
        [self.userDefault setValue:self.readChapters forKey:@"readChapters"];
        NSLog(@"After in Fav btn read chapter count == %i",self.readChapters.count);
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
    */
}
- (IBAction)showSettings:(id)sender {
    BAMSettings * settings = [[BAMSettings alloc]initWithTitle:@"Settings" propertyListNamed:@"Root"];
    settings.delegate = self.coreController;//(id) self.dataViewController;
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:settings];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

@end
