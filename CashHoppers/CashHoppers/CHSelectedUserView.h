//
//  CHSelectedUserView.h
//  CashHoppers
//
//  Created by Vova Musiienko on 30.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHUser;

@interface CHSelectedUserView : NSObject

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) CHUser* user;

@end
