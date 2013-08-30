//
//  CHUser.m
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHUser.h"
#import "CHAPIClient.h"

@implementation CHUser

- (void) updateFromDictionary:(NSDictionary*) dic{
    
    self.identifier = [dic objectForKey:@"id"];
    
    self.first_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"first_name"] defaultValue:@""];
    self.last_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"last_name"] defaultValue:@""];
    self.user_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"user_name"] defaultValue:@""];
    //self.zip;
    self.contact = [CHBaseModel safeStringFrom:[dic objectForKey:@"contact"] defaultValue:@""];
    self.phone = [CHBaseModel safeStringFrom:[dic objectForKey:@"phone"] defaultValue:@""];
    self.bio = [CHBaseModel safeStringFrom:[dic objectForKey:@"bio"] defaultValue:@""];
    self.twitter = [CHBaseModel safeStringFrom:[dic objectForKey:@"twitter"] defaultValue:@""];
    self.facebook = [CHBaseModel safeStringFrom:[dic objectForKey:@"facebook"] defaultValue:@""];
    self.google = [CHBaseModel safeStringFrom:[dic objectForKey:@"google"] defaultValue:@""];
    self.email = [CHBaseModel safeStringFrom:[dic objectForKey:@"email"] defaultValue:@""];
    self.role = [CHBaseModel safeStringFrom:[dic objectForKey:@"role"] defaultValue:@""];
    self.avatarUrlString = [CHBaseModel safeStringFrom:[dic objectForKey:@"avatar"] defaultValue:@""];
    self.friends_count = [CHBaseModel safeNumberFrom:[dic objectForKey:@"friends_count"] defaultValue:@0];
    self.friendship_status = [CHBaseModel safeStringFrom:[dic objectForKey:@"friendship_status"] defaultValue:nil];
    
}


- (NSURL*) avatarURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.avatarUrlString]];

}


- (void) fillForm:(id <AFMultipartFormData>)formData {
    [formData appendPartWithFormData:[self.first_name dataUsingEncoding:NSUTF8StringEncoding] name:@"first_name"];
    [formData appendPartWithFormData:[self.last_name dataUsingEncoding:NSUTF8StringEncoding] name:@"last_name"];
    [formData appendPartWithFormData:[self.contact dataUsingEncoding:NSUTF8StringEncoding] name:@"contact"];
    [formData appendPartWithFormData:[self.phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[self.bio dataUsingEncoding:NSUTF8StringEncoding] name:@"bio"];
    [formData appendPartWithFormData:[self.twitter dataUsingEncoding:NSUTF8StringEncoding] name:@"twitter"];
    [formData appendPartWithFormData:[self.facebook dataUsingEncoding:NSUTF8StringEncoding] name:@"facebook"];
    [formData appendPartWithFormData:[self.google dataUsingEncoding:NSUTF8StringEncoding] name:@"google"];
}


@end
