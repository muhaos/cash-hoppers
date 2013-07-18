//
//  CHHopTask.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@interface CHHopTask : CHBaseModel

@property (nonatomic, strong) NSNumber* identifier;
@property (nonatomic, strong) NSString* text;

- (void) updateFromDictionary:(NSDictionary*) dic;

@end
