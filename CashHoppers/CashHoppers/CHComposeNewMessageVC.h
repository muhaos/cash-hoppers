//
//  CHComposeNewMessageVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHComposeNewMessageVC : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UITextView *inputMessageTextView;

- (IBAction)deleteButtonTapped:(id)sender;
- (IBAction)replyMessageButtonTapped:(id)sender;

@end
