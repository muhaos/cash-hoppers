//
//  CHCommentListCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/9/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCommentListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoPerson;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
