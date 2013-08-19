//
//  CHAdvertisingVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAdvertisingVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *reclamaImageView;
@property (strong, nonatomic) IBOutlet UIView* container;

@property (strong, nonatomic) CHAdvertisingVC* selfRef;

@property (nonatomic, strong) NSString* adsImageUrlString;
@property (nonatomic, strong) NSString* adsLinkUrlString;

@property (nonatomic, assign) UIViewController* ownerController;

- (IBAction)closeTapped:(id)sender;
- (IBAction)adsTapped:(id)sender;

+ (CHAdvertisingVC*) instanceWithAdType:(NSString*)adType andHopID:(NSNumber*) hopID;
- (void) loadAdWithAdType:(NSString*)adType andHopID:(NSNumber*) hopID;

+ (BOOL) isShowed;
+ (void) hide;

@end
