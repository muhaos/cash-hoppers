//
//  CHMessageNotification.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/29/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseNotification.h"

@class CHUser;

@interface CHMessageNotification : CHBaseNotification

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSNumber* sender_id;
@property (nonatomic, strong) NSString* time_ago;
@property (nonatomic, strong) CHUser* senderUser;
@property (nonatomic, strong) NSString* friend_avatar;
@property (nonatomic, strong) NSString* friend_first_name;
@property (nonatomic, strong) NSString* friend_last_name;

- (NSURL*) friendAvatarURL;
- (void) updateFromDictionary:(NSDictionary*) dic;
- (NSAttributedString*) notificationDescription;

@end
