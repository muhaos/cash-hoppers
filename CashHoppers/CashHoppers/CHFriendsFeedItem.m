//
//  CHFriendsFeedItem.m
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendsFeedItem.h"
#import "CHHop.h"
#import "CHHopTask.h"
#import "CHAPIClient.h"

@implementation CHFriendsFeedItem


- (void) updateFromDictionary:(NSDictionary*) dic {
    
    self.userID = [dic objectForKey:@"user_id"];
    self.hopID = [dic objectForKey:@"hop_id"];
    self.hopTaskID = [dic objectForKey:@"hop_task_id"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.createdAt = [df dateFromString: [dic objectForKey:@"created_at"]];
    
    self.comment = [CHBaseModel safeStringFrom:[dic objectForKey:@"comment"] defaultValue:@""];
    self.liked = [dic objectForKey:@"liked"];
    self.numberOfLikes = [dic objectForKey:@"likes_count"];
    self.photoURL = [CHBaseModel safeStringFrom:[dic objectForKey:@"photo"] defaultValue:@""];
}


- (NSURL*) hopImageURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.photoURL]];
}


- (NSString*) completedTaskName {
    for (CHHopTask* t in self.hop.tasks) {
        if ([t.identifier intValue] == [self.hopTaskID intValue]) {
            return t.text;
        }
    }
    return @"No Task Name";
}


@end
