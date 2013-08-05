//
//  CHBaseNotification.h
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

enum CHNotificationType {
    CHNotificationTypeNone = 0,
    CHNotificationTypeFriendInvite,
    CHNotificationTypeEndOfHop,
    CHNotificationTypeComment,
    CHNotificationTypeLike,
    CHNotificationTypeFriendInviteAccepted
};
    

@interface CHBaseNotification : CHBaseModel

@property (nonatomic, assign) enum CHNotificationType notificationType;

@property (nonatomic, retain) NSString* event_type;
@property (nonatomic, retain) NSString* time_ago;

@property (nonatomic, retain) NSString* userAvatarURLString;
@property (nonatomic, retain) NSString* userName;

- (NSString*) notificationDescription; // overwrited by childs
- (void) loadParts;
- (NSURL*) userAvatarURL;

- (void) updateFromDictionary:(NSDictionary*) dic;

+ (enum CHNotificationType) notificationTypeFromString:(NSString*) typeStr;

@end
