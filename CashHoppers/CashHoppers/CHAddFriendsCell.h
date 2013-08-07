//
//  CHAddFriendsCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CHAddFriendsSocialNetworksVC.h"

@protocol CHAddFriendCellDelegate <NSObject>
@optional
- (void) selectedFollowerWithID:(NSString*) fID;
@end

@interface CHAddFriendsCell : UITableViewCell <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) id <CHAddFriendCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary* userDic;

- (IBAction)addFriendTapped:(id)sender;

@end
