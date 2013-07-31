//
//  CHMessagesManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"
#import "CHMessage.h"

@interface CHMessagesManager : CHBaseManager

+ (CHMessagesManager*) instance;

- (void) loadMessagesOverviewWithCompletionHandler:(void (^)(NSArray* messages)) handler;

- (void) postMessageWithText:(NSString*) text toFriendsList:(NSArray*)friendsIds completionHandler:(void (^)(NSError* error))handler;



@end
