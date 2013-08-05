//
//  CHBaseManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHBaseModel;

@interface CHBaseManager : NSObject

- (void) defaultErrorHandlerForReqest:(NSURLRequest*) request responce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON;

- (CHBaseModel*) findObjectWithID:(NSNumber*)_id inArray:(NSArray*) array;

@end
