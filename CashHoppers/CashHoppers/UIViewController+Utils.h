//
//  UIViewController+Utils.h
//  CashHoppers
//
//  Created by Vova Musiienko on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

- (void) setupTriangleBackButton;

// ads
- (void) showAdsWithType:(NSString*) adsType andHopID:(NSNumber*) hopID;

@end
