//
//  CHMessage.h
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@class CHUser;

@interface CHMessage : CHBaseModel

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSNumber* sender_id;
@property (nonatomic, strong) NSString* time_ago;

@property (nonatomic, strong) CHUser* senderUser;

// usable only on messages overview
@property (nonatomic, strong) NSNumber* friend_id;
@property (nonatomic, strong) NSString* friend_avatar;
@property (nonatomic, strong) NSString* friend_first_name;
@property (nonatomic, strong) NSString* friend_last_name;
@property (nonatomic, strong) NSString* friend_user_name;

- (NSURL*) friendAvatarURL;

- (void) updateFromDictionary:(NSDictionary*) dic;

@end
