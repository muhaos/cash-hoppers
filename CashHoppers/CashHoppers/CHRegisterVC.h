//
//  CHRegisterVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/20/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHRegisterVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *requiredLabel;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *zipView;

- (IBAction)registerTapped:(id)sender;

@end
