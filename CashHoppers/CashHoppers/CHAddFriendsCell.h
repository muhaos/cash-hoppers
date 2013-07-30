//
//  CHAddFriendsCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAddFriendsCell : UITableViewCell
{
	NSDictionary *data;
    NSString *requestPath;
}

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) NSDictionary *data;
@property(nonatomic, retain) NSString *requestPath;

- (IBAction)addFriendTapped:(id)sender;

@end
