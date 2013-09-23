//
//  CHHopTask.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@class CHHop;

@interface CHHopTask : CHBaseModel

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSNumber* completed;
@property (nonatomic, strong) CHHop* hop;
@property (nonatomic, strong) NSString* logoUrlString;
@property (nonatomic, strong) NSString* photoUrlString;
@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) NSNumber* points;
@property (nonatomic, strong) NSNumber* share;
@property (nonatomic, strong) NSString* adUrlString;
@property (nonatomic, strong) NSNumber* bonusPoints;


- (void) updateFromDictionary:(NSDictionary*) dic;
- (NSURL*) logoURL;
- (NSURL*) photoURL;
- (NSURL*) adURL;

@end
