//
//  CHSelectedUserView.m
//  CashHoppers
//
//  Created by Vova Musiienko on 30.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHSelectedUserView.h"

@implementation CHSelectedUserView

- (id)init
{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CHSelectedUserView" owner:self options:nil];
    }
    return self;
}

@end
