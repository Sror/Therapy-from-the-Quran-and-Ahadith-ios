//
//  DiaryCellViewController.m
//  Diary
//
//  Created by ahadnawaz on 28/02/2013.
//  Copyright (c) 2013 ahadnawaz. All rights reserved.
//

#import "CustomCellViewController.h"

@implementation CustomCellViewController
@synthesize label;
@synthesize chapterImageView;

-(id)init
{
    self=[super init];
//    self.first=YES;
    return self;
}
 
- (IBAction)favourit:(id)sender {
    //    diaryDataSource *ds=[[diaryDataSource alloc]init];
    //
    //    self.row_id=self.favBtn.tag;
    //    if(self.favBtn.imageView.image == [UIImage imageNamed:@"notfav.png"]){
    //        [self.favBtn setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    ////         self.first = NO;
    //        NSLog(@"row id = %d",self.row_id);
    //        NSLog(@"added to fav %c",[ds isFav:0 rowId:self.row_id]);
    //    }
    //    else
    //    {
    ////        self.first = YES;
    //        [self.favBtn setImage:[UIImage imageNamed:@"notfav.png"] forState:UIControlStateNormal];
    //        NSLog(@"Removed from fav list %c",[ds isFav:1 rowId:self.row_id]);
    //
    //    }
}

@end