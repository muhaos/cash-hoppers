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

@property (nonatomic, retain) NSArray* dailyHops;
@property (nonatomic, retain) NSArray* otherHops;

- (void) refreshHops;
- (void) refreshDailyHops;
- (void) refreshOtherHops;

- (void) completeHopTask:(CHHopTask*) hopTask withPhoto:(UIImage*) photo comment:(NSString*) comment completionHandler:(void (^)(BOOL success))handler;

- (void) loadHopForID:(NSNumber*) _id completionHandler:(void (^)(CHHop* hop)) handler;


@end
