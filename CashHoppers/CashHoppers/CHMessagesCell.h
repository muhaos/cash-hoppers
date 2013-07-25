//
//  CHMessagesCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/18/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMessagesCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *likeCommentImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteButtonTapped:(id)sender;

@end
