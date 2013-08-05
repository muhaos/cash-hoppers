//
//  CHEndOfHopNotification.h
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseNotification.h"

@class CHHop;

@interface CHEndOfHopNotification : CHBaseNotification

@property (nonatomic, retain) NSNumber* hopID;
@property (nonatomic, retain) CHHop* hop;
@property (nonatomic, retain) NSNumber* cost;
@property (nonatomic, retain) NSNumber* place;


- (NSAttributedString*) notificationDescription;
- (void) updateFromDictionary:(NSDictionary*) dic;

@end
