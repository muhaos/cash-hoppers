//
//  CHHop.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@interface CHHop : CHBaseModel

@property (nonatomic, strong) NSNumber* identifier;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSDate* time_start;
@property (nonatomic, strong) NSDate* time_end;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* price;
@property (nonatomic, strong) NSNumber* jackpot;
@property (nonatomic, strong) NSNumber* daily_hop; //BOOL
@property (nonatomic, strong) NSNumber* close; //BOOL
@property (nonatomic, strong) NSString* event;

@property (nonatomic, strong) NSArray* tasks; // CHHopTask

- (void) updateFromDictionary:(NSDictionary*) dic;


@end
