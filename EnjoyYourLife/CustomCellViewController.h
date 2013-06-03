//
//  DiaryCellViewController.h
//  Diary
//
//  Created by ahadnawaz on 28/02/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface CustomCellViewController : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *chapterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *readImageView;
@property (strong, nonatomic) IBOutlet UILabel *rowNumber;
 
- (IBAction)favourit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *favBtn;

 @property BOOL first;
@property int  row_id;

 
@end
