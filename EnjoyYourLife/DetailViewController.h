//
//  DetailViewController.h
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 3/5/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *bookTextView;
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureRecognizer;
@end
