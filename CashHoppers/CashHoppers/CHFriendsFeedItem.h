//
//  CHFriendsFeedItem.h
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"

@class CHUser;
@class CHHopTask;
@class CHHop;

@interface CHFriendsFeedItem : CHBaseModel


@property(nonatomic,strong) NSNumber *userID;
@property(nonatomic,strong) NSNumber *hopTaskID;
@property(nonatomic,strong) NSDate *createdAt;
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSNumber *hopID;
@property(nonatomic,strong) NSString *photoURL;
@property(nonatomic,strong) NSNumber *numberOfLikes;
@property(nonatomic,strong) NSNumber *liked;
@property(nonatomic,strong) NSString* time_ago;
@property(nonatomic,strong) CHUser *user;
@property(nonatomic,strong) CHHop *hop;

- (NSString*) completedTaskName;
- (NSURL*) hopImageURL;

- (void) updateFromDictionary:(NSDictionary*) dic;

@end
