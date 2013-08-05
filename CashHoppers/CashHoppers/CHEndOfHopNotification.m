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


- (NSAttributedString*) notificationDescription {
    NSString* resultStr = nil;
    if (self.hop != nil) {
        resultStr = [NSString stringWithFormat:@"The \"%@\" hop #%i winner. Prize is $%i", self.hop.name, [self.place intValue], [self.cost intValue]];
    }
    resultStr = [NSString stringWithFormat:@"The #%i winner. Prize is $%i", [self.place intValue], [self.cost intValue]];
    return [self attributedString:resultStr withBoldString:nil];
}


@end
