//
//  CHComposeNewMessageVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHComposeNewMessageVC.h"
#import <QuartzCore/QuartzCore.h>

@interface CHComposeNewMessageVC ()

@end

@implementation CHComposeNewMessageVC
@synthesize photoImageView, nameLabel, timeLabel, messageTextView, inputMessageTextView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    photoImageView.image = [UIImage imageNamed:@"photo_BrianKelly.png"];
    [nameLabel setText:@"Brian Kelly"];
    [timeLabel setText:@"15 min ago"];
    [messageTextView setText:@"Hey!: Hey. How did you find the models at the American Apparel"];
    
    inputMessageTextView.layer.cornerRadius = 3;
    inputMessageTextView.layer.borderColor = [UIColor colorWithRed:232.0f/256 green:232.0f/256 blue:232.0f/256 alpha:1.0f].CGColor;
    inputMessageTextView.layer.borderWidth = 1.0f;
    [inputMessageTextView setText:@"Reply to message ..."];
    [inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];
}


- (void) backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}


-(void) textViewDidBeginEditing:(UITextView *)textView
{
    [inputMessageTextView setText:@""];
    [inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];
}


- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setNameLabel:nil];
    [self setTimeLabel:nil];
    [self setMessageTextView:nil];
    [self setInputMessageTextView:nil];
    [super viewDidUnload];
}


- (IBAction)deleteButtonTapped:(id)sender
{
    
}


- (IBAction)replyMessageButtonTapped:(id)sender
{
    
}

@end
