//
//  CHAdditionalSigninFormVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAdditionalSigninFormVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (strong, nonatomic) NSString* screenNameUser;
@property (strong, nonatomic) NSString* firstNameUser;
@property (strong, nonatomic) NSString* lastNameUser;
@property (strong, nonatomic) NSString* emailUser;
@property (strong, nonatomic) NSString* idUser;
@property (strong, nonatomic) UIImage* imageUser;
@property (strong, nonatomic) NSString* provider;

- (IBAction)registerButtonTapped:(id)sender;

@end
