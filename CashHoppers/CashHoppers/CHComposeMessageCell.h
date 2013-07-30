//
//  CHComposeMessageCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHComposeMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)composeButtonTapped:(id)sender;

@end
