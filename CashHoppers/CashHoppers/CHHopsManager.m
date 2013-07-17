//
//  CHHopsManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopsManager.h"
#import "CHAPIClient.h"

@interface CHHopsManager ()

@property (nonatomic, strong) NSMutableArray* hops;

@end


@implementation CHHopsManager

+ (CHHopsManager*) instance {
    static CHHopsManager* inst = nil;
    if (inst == nil) {
        inst = [[CHHopsManager alloc] init];
        
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        self.hops = [NSMutableArray new];
    }
    return self;
}


- (void) refreshHops {
    //NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hops?api_key=%@", CH_API_KEY];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];

    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [self.hops removeAllObjects];
        
        NSArray* hops = [JSON objectForKey:@"hops"];
        if (hops) {
            for (NSDictionary* objDic in hops) {
                CHHop* newHop = [[CHHop alloc] init];
                [newHop updateFromDictionary:objDic];
                [self.hops addObject:newHop];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_UPDATED object:self];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForResponce:response :error :JSON];
    }];
    
    [operation start];
}


@end
