//
//  CHFriendsFeedItem.m
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendsFeedItem.h"

@implementation CHFriendsFeedItem


//@dynamic userID;
//@dynamic hopID;
//@dynamic comment;
//@dynamic createdAt;
//@dynamic hopTaskID;
//@dynamic liked;
//@dynamic numberOfLikes;
//@dynamic photoURL;


- (void) updateFromDictionary:(NSDictionary*) dic {
    
    self.userID = [dic objectForKey:@"user_id"];
    self.hopID = [dic objectForKey:@"hop_id"];
    self.hopTaskID = [dic objectForKey:@"hop_task_id"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.createdAt = [df dateFromString: [dic objectForKey:@"created_at"]];
    
    self.comment = [self safeStringFrom:[dic objectForKey:@"comment"] defaultValue:@""];
    self.liked = [dic objectForKey:@"liked"];
    self.numberOfLikes = [dic objectForKey:@"likes_count"];
    self.photoURL = [self safeStringFrom:[dic objectForKey:@"photo"] defaultValue:@""];
}

@end
