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

    self.identifier = [dic objectForKey:@"id"];
    self.userID = [dic objectForKey:@"user_id"];
    self.hopID = [dic objectForKey:@"hop_id"];
    self.hopTaskID = [dic objectForKey:@"hop_task_id"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.createdAt = [df dateFromString: [dic objectForKey:@"created_at"]];
    
    self.comment = [CHBaseModel safeStringFrom:[dic objectForKey:@"comment"] defaultValue:@""];
    self.liked = [dic objectForKey:@"liked"];
    self.numberOfLikes = [dic objectForKey:@"likes_count"];
    
    ////
    self.numberOfComments = [dic objectForKey:@"comments_count"];
    /////
    
    self.photoURL = [CHBaseModel safeStringFrom:[dic objectForKey:@"photo"] defaultValue:@""];
    self.smallPhotoURL = [CHBaseModel safeStringFrom:[dic objectForKey:@"small_photo"] defaultValue:@""];
    self.time_ago = [CHBaseModel safeStringFrom:[dic objectForKey:@"time_ago"] defaultValue:@"some time ago"];
    self.likers = [dic objectForKey:@"likers"];
}


+ (BOOL) isValidFeedDictionary:(NSDictionary*) dic {
    if ([CHBaseModel isObjectNil:[dic objectForKey:@"id"]] ||
        [CHBaseModel isObjectNil:[dic objectForKey:@"user_id"]] ||
        [CHBaseModel isObjectNil:[dic objectForKey:@"hop_id"]] ||
        [CHBaseModel isObjectNil:[dic objectForKey:@"hop_task_id"]]) {
        return NO;
    }
    return YES;
}


- (NSURL*) hopImageURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.photoURL]];
}


- (NSURL*) smallHopImageURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.smallPhotoURL]];
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
