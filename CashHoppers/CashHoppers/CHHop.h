//
//  CHHop.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

enum CHHopType {
    CHHopTypeFree = 0,
    CHHopTypeWithEntryFee,
    CHHopTypeWithCode,
    CHHopTypeCompleted
};


@interface CHHop : CHBaseModel

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
- (enum CHHopType) hopType;
- (BOOL) isAllTasksCompleted;
- (NSString*) dateString;

- (void) updateFromDictionary:(NSDictionary*) dic;
+ (BOOL) isValidHopDictionary:(NSDictionary*) dic;

@end
