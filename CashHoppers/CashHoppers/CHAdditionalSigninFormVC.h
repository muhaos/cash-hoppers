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
@property (assign, nonatomic) NSString* screenNameUser;
@property (assign, nonatomic) NSString* firstNameUser;
@property (assign, nonatomic) NSString* lastNameUser;
@property (assign, nonatomic) NSString* emailUser;
@property (assign, nonatomic) NSString* idUser;
@property (assign, nonatomic) UIImage* imageUser;

- (IBAction)registerButtonTapped:(id)sender;

@end
