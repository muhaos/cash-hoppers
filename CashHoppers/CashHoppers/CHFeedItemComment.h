//
//  CHFeedItemComment.h
//  CashHoppers
//
//  Created by Eugene on 29.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@class CHUser;

@interface CHFeedItemComment : CHBaseModel

@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate* created_at;
@property (nonatomic, strong) CHUser* user;

- (void) updateFromDictionary:(NSDictionary*) dic;

@end
