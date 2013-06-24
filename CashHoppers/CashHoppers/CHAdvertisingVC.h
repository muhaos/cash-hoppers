//
//  CHAdvertisingVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAdvertisingVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *reclamaImageView;
@property (strong, nonatomic) IBOutlet UILabel *bottomHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
- (IBAction)closeTapped:(id)sender;

+ (CHAdvertisingVC*) sharedAdverticingVC;
- (void) showInController:(UIViewController*) c
                 withHeaderLabel:(NSString*) header
                withImage:(UIImage*) image
    withBottomHeaderLabel:(NSString*) bottomHeader
          withBottomLabel:(NSString*)bottom;
@end
