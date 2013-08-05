//
//  CHBaseNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseNotification.h"
#import "CHAPIClient.h"

@implementation CHBaseNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    self.event_type = [CHBaseModel safeStringFrom:[dic objectForKey:@"event_type"] defaultValue:nil];
    self.time_ago = [CHBaseModel safeStringFrom:[dic objectForKey:@"time_ago"] defaultValue:@"some time ago"];
    
    self.notificationType = [CHBaseNotification notificationTypeFromString:self.event_type];
}


- (NSAttributedString*) notificationDescription {
    return [[NSMutableAttributedString alloc] initWithString:@"Accepted you invitation."];
}


- (NSURL*) userAvatarURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.userAvatarURLString]];
}


+ (enum CHNotificationType) notificationTypeFromString:(NSString*) typeStr {
    if ([typeStr isEqualToString:@"Friend invite"]) {
        return CHNotificationTypeFriendInvite;
    } else if ([typeStr isEqualToString:@"End of hop"]) {
        return CHNotificationTypeEndOfHop;
    } else if ([typeStr isEqualToString:@"Comment"]) {
        return CHNotificationTypeComment;
    } else if ([typeStr isEqualToString:@"Like"]) {
        return CHNotificationTypeLike;
    } else if ([typeStr isEqualToString:@"Friend invite accept"]) {
        return CHNotificationTypeFriendInviteAccepted;
    }
    return CHNotificationTypeNone;
}


- (void) loadParts {
    // nothing to do there
}


- (NSAttributedString*) attributedString:(NSString*) wholeStr withBoldString:(NSString*) boldPartStr {

    NSDictionary *boldAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans-Bold" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]};
    NSDictionary *normAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]};
    
    NSMutableAttributedString* mStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    
    NSInteger str_length = [wholeStr length];
    
    [mStr setAttributes:normAttribs range:NSMakeRange(0, str_length)];
    if (boldPartStr != nil) {
        [mStr setAttributes:boldAttribs range:[wholeStr rangeOfString:boldPartStr]];
    }
    
    return mStr;
}


@end
