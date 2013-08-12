//
//  CHUserManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 26.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"
#import "CHUser.h"

@interface CHUserManager : CHBaseManager

+ (CHUserManager*) instance;

@property (nonatomic, strong, readonly) CHUser* currentUser;
- (void) updateCurrentUser;

- (void) loadUserForID:(NSNumber*) _id completionHandler:(void (^)(CHUser* user)) handler;

- (void) updateUserProfileWithUser:(CHUser*) user newPassword:(NSString*)password newAvatar:(UIImage*)avatar completionHandler:(void (^)(NSError* error)) handler;

- (void) loadFriendsWithCompletionHandler:(void (^)(NSArray* friends)) handler;

- (void) searchUsersWithQuery:(NSString*) searchStr andCompletionHandler:(void (^)(NSArray* users)) handler;

- (void) sendFriendInvitationToUser:(CHUser*) user withCompletionHandler:(void (^)(NSError* error)) handler;

- (void) acceptFriendRequestForFriendID:(NSNumber*)friendID completionHandler:(void (^)(NSError* error)) handler;

- (void) declineFriendRequestForFriendID:(NSNumber*)friendID completionHandler:(void (^)(NSError* error)) handler;

@end
