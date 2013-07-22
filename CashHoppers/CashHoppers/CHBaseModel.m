//
//  CHBaseModel.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@implementation CHBaseModel

- (NSString*) safeStringFrom:(NSString*) inStr defaultValue:(NSString*) defStr {
    if (inStr == nil || [inStr isKindOfClass:[NSNull class]] || [inStr isEqualToString:@""]) {
        return defStr;
    }
    return inStr;
}


- (NSNumber*) safeNumberFrom:(NSNumber*) inNum defaultValue:(NSNumber*) defNum {
    if (inNum == nil || [inNum isKindOfClass:[NSNull class]]) {
        return defNum;
    }
    return inNum;
}


- (NSDate*) safeDateFrom:(NSString*) inDate dateFromatter:(NSDateFormatter*)df defaultValue:(NSDate*) defDate {
    if (inDate == nil || [inDate isKindOfClass:[NSNull class]] || [inDate isEqualToString:@""]) {
        return defDate;
    }
    return [df dateFromString: inDate];
}

@end
