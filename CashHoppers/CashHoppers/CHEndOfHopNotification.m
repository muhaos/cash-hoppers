//
//  CHEndOfHopNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHEndOfHopNotification.h"
#import "CHHop.h"

@implementation CHEndOfHopNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];

    NSDictionary* prizeDic = [dic objectForKey:@"prize"];
    NSDictionary* friendDic = [prizeDic objectForKey:@"user"];
    
    self.userAvatarURLString = [friendDic objectForKey:@"avatar"];
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];
}


- (NSString*) notificationDescription {
    if (self.hop != nil) {
        return [NSString stringWithFormat:@"The \"%@\" hop #%i winner. Prize is $%i", self.hop.name, [self.place intValue], [self.cost intValue]];
    }
    return [NSString stringWithFormat:@"The #%i winner. Prize is $%i", [self.place intValue], [self.cost intValue]];
}


@end
