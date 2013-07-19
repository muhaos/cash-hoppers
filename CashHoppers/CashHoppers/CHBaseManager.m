//
//  CHBaseManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"

@implementation CHBaseManager

- (void) defaultErrorHandlerForResponce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON {
    NSString* errMsg = nil;
    if (JSON != nil) {
        errMsg = [JSON  objectForKey:@"info"];
    } else {
        errMsg = [error localizedDescription];
    }
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REPORTS" message:[NSString stringWithFormat:@"Can't get reports list: %@", errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}


@end