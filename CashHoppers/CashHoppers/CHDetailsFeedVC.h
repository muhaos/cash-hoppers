//
//  CHDetailsFeedVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/9/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHDetailsFeedVC : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *photoPersonImageView;
@property (strong, nonatomic) IBOutlet UILabel *namePersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskCompletedLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoHopImageView;
@property (strong, nonatomic) IBOutlet UILabel *countLikeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countCommentLabel;
@property (strong, nonatomic) IBOutlet UITextView *likePersonTextView;
@property (strong, nonatomic) IBOutlet UITableView *commentTable;
@property (strong, nonatomic) IBOutlet UITextView *addComentTextView;
@property (strong, nonatomic) IBOutlet UIButton *postCommentButton;
@property (strong, nonatomic) IBOutlet UIScrollView *myScroolView;

- (IBAction)postCommentTapped:(id)sender;

@end
