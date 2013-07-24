//
//  CHBaseModel.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHBaseModel : NSObject

@property (nonatomic, retain) NSNumber* identifier;

+ (NSString*) safeStringFrom:(NSString*) inStr defaultValue:(NSString*) defStr;
+ (NSNumber*) safeNumberFrom:(NSNumber*) inNum defaultValue:(NSNumber*) defNum;
+ (NSDate*) safeDateFrom:(NSString*) inDate dateFromatter:(NSDateFormatter*)df defaultValue:(NSDate*) defDate;


@end
