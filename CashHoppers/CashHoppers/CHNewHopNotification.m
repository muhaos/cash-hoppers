//
//  CHNewHopNotification.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/29/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHNewHopNotification.h"
#import "CHHop.h"

@implementation CHNewHopNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];
    
//    NSDictionary *hopDic = [NSDictionary new];
//
//    if ([dic objectForKey:@"hop"] != nil && ![[dic objectForKey:@"hop"] isEqual: @"<null>"]) {
//        hopDic = [dic objectForKey:@"hop"];
//    }
//    
//   
//  //  self.hopName = [hopDic objectForKey:@"name"];
// //   NSLog(@"%@", hopDic);
//    self.hopName = [NSString stringWithFormat:@"%@", [hopDic objectForKey:@"first_name"]];
}


- (NSAttributedString*) notificationDescription {
    NSString* resultStr = nil;
    resultStr = [NSString stringWithFormat:@"The \"%@\" hop start.", self.hopName];
    return [self attributedString:resultStr withBoldString:nil];
}

@end
