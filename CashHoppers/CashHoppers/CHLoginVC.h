//
//  CHLoginVC.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHLoginVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginTapped:(id)sender;
-(IBAction)hideKeyboard:(id)sender;

@end
