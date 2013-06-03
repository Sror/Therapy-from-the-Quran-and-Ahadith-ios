//
//  NotesViewController.h
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 4/1/13.
//  Copyright (c) 2013 D-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface NotesViewController : UIViewController
@property (nonatomic) int chapterID;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *notesTextView;

@end
