//
//  CHOptionalPopupSharingVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHOptionalPopupSharingVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nameSharingLabel;

- (IBAction)okButtonTapped:(id)sender;
- (IBAction)noButtonTapped:(id)sender;

+ (CHOptionalPopupSharingVC*) sharedOptionalPopupVC;
- (void) showInController:(UIViewController*) c withText:(NSString*) text;
- (void) hide;

@end
