//
//  CHBaseManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHBaseManager : NSObject

- (void) defaultErrorHandlerForResponce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON;

@end
