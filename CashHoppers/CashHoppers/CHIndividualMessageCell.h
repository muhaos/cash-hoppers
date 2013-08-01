//
//  CHIndividualMessageCell.h
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHIndividualMessageCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView* avatarImageView;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UITextView* messageTextView;


@end
