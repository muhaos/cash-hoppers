//
//  CHMessageNotification.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/29/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMessageNotification.h"
#import "CHAPIClient.h"

@implementation CHMessageNotification


- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];

    NSDictionary *friendDic = [NSDictionary new];
    friendDic = [dic objectForKey:@"friend"];
    
    NSDictionary *messageDic = [NSDictionary new];
    messageDic = [dic objectForKey:@"message"];
    
    self.text = [messageDic objectForKey:@"text"];
    self.userAvatarURLString = [CHBaseModel safeStringFrom:[friendDic objectForKey:@"avatar"] defaultValue:nil] ;
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];
    self.sender_id = [CHBaseModel safeNumberFrom:[dic objectForKey:@"sender_id"] defaultValue:nil];
    self.time_ago = [CHBaseModel safeStringFrom:[dic objectForKey:@"time_ago"] defaultValue:@"some time ago"];
    self.friend_avatar = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_avatar_file_name"] defaultValue:@""];
    self.friend_first_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_first_name"] defaultValue:@"No First Name"];
    self.friend_last_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_last_name"] defaultValue:@"No Last Name"];
}


- (NSURL*) friendAvatarURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.friend_avatar]];
}


- (NSAttributedString*) notificationDescription {
    NSString* resultStr = nil;
    resultStr = [NSString stringWithFormat:@"%@", self.text];
    return [self attributedString:resultStr withBoldString:nil];
}


@end
