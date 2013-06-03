//
//  DetailViewController.m
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 3/5/13.
//  Copyright (c) 2013 Darussalam Publications. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"45" ofType:@"txt"];
    NSData * data = [[NSFileManager defaultManager] contentsAtPath:path];
    self.bookTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleTap:(UITapGestureRecognizer*)gestureRecognizer{
    
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.hidden animated:YES];
}

@end
