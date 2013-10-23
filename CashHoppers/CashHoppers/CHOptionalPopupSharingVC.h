//
//  CHOptionalPopupSharingVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPShare.h"
#define CH_SHARING_SERVICE_FACEBOOK 1
#define CH_SHARING_SERVICE_GOOGLE 2
#define CH_SHARING_SERVICE_TWITTER 3

@interface CHOptionalPopupSharingVC : UIViewController <GPPShareDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameSharingLabel;
@property (strong, nonatomic) UIImage* imageToShare;

- (IBAction)okButtonTapped:(id)sender;
- (IBAction)noButtonTapped:(id)sender;

+ (CHOptionalPopupSharingVC*) sharedOptionalPopupVC;
- (void) showInController:(UIViewController*) c withText:(NSString*) text;

@property (nonatomic, assign) int currentSharingService;

@end
