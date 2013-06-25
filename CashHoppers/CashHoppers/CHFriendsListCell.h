//
//  CHFriendsListCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHFriendsListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoPersonImageView;
@property (strong, nonatomic) IBOutlet UILabel *namePersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskCompletedLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoHopImageView;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *numberCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLikesLabel;


- (IBAction)commentTapped:(id)sender;
- (IBAction)likeTapped:(id)sender;

@end
