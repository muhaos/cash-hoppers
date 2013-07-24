//
//  CHUser.h
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@interface CHUser : CHBaseModel

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (void) updateFromDictionary:(NSDictionary*) dic;

@end
