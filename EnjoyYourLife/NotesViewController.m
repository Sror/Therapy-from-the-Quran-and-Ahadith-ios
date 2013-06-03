//
//  NotesViewController.m
//  EnjoyYourLife
//
//  Created by Faiz Rasool on 4/1/13.
//  Copyright (c) 2013 D-Tech. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    DataSource * ds = [DataSource sharedInstance];
    
    NSString * chapterNotes = [ds GetNotesForChapterId:self.chapterID ] ;
//    if(chapterNotes.count >= 2)
//    {
//        NSString *notesDate =[chapterNotes objectAtIndex:0];
//        NSString *notes = [chapterNotes objectAtIndex:1];
        [self.notesTextView setText:[NSString stringWithFormat:@"%@\n",chapterNotes]];
//    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [self.notesTextView setText:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Notes";
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //    item.image = [UIImage imageNamed:@"back.png"];
    self.navigationItem.leftBarButtonItem = item;

    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"button@2x.png"] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    saveBtn.frame = CGRectMake(0, 0, 50, 30);
    [saveBtn addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * barItm = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    //    item.image = [UIImage imageNamed:@"back.png"];
    self.navigationItem.rightBarButtonItem = barItm;

}

- (void) saveButtonTapped{
    DataSource * ds = [DataSource sharedInstance];
    
    //if([self.notesTextView.text isEqualToString:@""])
    
    int error = [ds AddNotes:self.notesTextView.text ForChapterId:self.chapterID];
    if(error == 0){
        UIAlertView * alrt = [[UIAlertView alloc]initWithTitle:@"Notes saved successfully." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alrt show];
        [self dismissModalViewControllerAnimated:YES];
    }
    
   // else
    //    [ds UpdateNotes:self.notesTextView.text ForChapterId:self.chapterID];
}

- (void) cancelButtonTapped{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNotesTextView:nil];
    [super viewDidUnload];
}

@end
