//
//  CHResetPasswordVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/20/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHResetPasswordVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)signInTapped:(id)sender;

@end
