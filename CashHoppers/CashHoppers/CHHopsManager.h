//
//  CHHopsManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"
#import "CHHop.h"
#import "CHHopTask.h"

// messages
#define CH_HOPS_UPDATED @"CH_HOPS_UPDATED"
#define CH_HOPS_TASKS_UPDATED @"CH_HOPS_TASKS_UPDATED"


@interface CHHopsManager : CHBaseManager

+ (CHHopsManager*) instance;

@property (nonatomic, retain) CHHop* dailyHop;
@property (nonatomic, retain) NSMutableArray* otherHops;

- (void) refreshHops;


@end
