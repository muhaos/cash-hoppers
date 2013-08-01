//
//  CHUser.h
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseModel.h"
#import "CHAPIClient.h"

@interface CHUser : CHBaseModel

@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *google;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *avatarUrlString;
@property (nonatomic, strong) NSNumber *friends_count;

- (NSURL*) avatarURL;

- (void) updateFromDictionary:(NSDictionary*) dic;
- (void) fillForm:(id <AFMultipartFormData>)formData;

@end
