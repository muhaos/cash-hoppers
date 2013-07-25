//
//  CHProfileUserVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/23/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHProfileUserVC : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *twitterTextField;
@property (strong, nonatomic) IBOutlet UITextField *facebookTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)photoButtonTapped:(id)sender;

@end
