//
//  CHBaseManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"
#import "CHBaseModel.h"
#import "CHAPIClient.h"

@implementation CHBaseManager

- (void) defaultErrorHandlerForReqest:(NSURLRequest*) request responce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON {
    NSString* errMsg = nil;
    if (JSON != nil && [JSON  objectForKey:@"info"]) {
        errMsg = [JSON  objectForKey:@"info"];
    } else {
        errMsg = [error localizedDescription];
    }
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't load url: %@ \n %@", request.URL, errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}


- (void) requestWithMethod:(NSString*) method :(NSString*)path :(void (^)(NSError* error)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *full_path = [path stringByAppendingFormat:@"&api_key=%@&authentication_token=%@", CH_API_KEY, aToken];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:method path:full_path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        handler(nil);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(error);
    }];
    
    [operation start];
}


- (CHBaseModel*) findObjectWithID:(NSNumber*)_id inArray:(NSArray*) array {
    for (CHBaseModel* obj in array) {
        if ([_id intValue] == [obj.identifier intValue]) {
            return obj;
        }
    }
    return nil;
}

@end
