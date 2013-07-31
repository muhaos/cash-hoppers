//
//  CHMessage.h
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@interface CHMessage : CHBaseModel

@property (nonatomic, strong) NSString* text;

- (void) updateFromDictionary:(NSDictionary*) dic;

@end
