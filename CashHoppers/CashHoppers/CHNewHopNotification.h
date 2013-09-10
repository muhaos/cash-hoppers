//
//  CHNewHopNotification.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/29/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseNotification.h"

@class CHHop;

@interface CHNewHopNotification : CHBaseNotification

@property (nonatomic, strong) NSString *hopName;
@property (nonatomic, strong) NSString* hopLogoURLString;
@property (nonatomic, strong) NSNumber *hopID;
@property (nonatomic, strong) NSNumber *isDailyHop;

- (NSAttributedString*) notificationDescription;
- (void) updateFromDictionary:(NSDictionary*) dic;

@end
