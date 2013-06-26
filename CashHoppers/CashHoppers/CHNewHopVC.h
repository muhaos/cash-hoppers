//
//  CHNewHopVC.h
//  CashHoppers
//
//  Created by Eugene on 24.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//
#define CH_NUMBER_OF_CHARACTERS 140
#define CH_GRAY_COLOR [UIColor colorWithWhite:.9 alpha:.8]

#import <UIKit/UIKit.h>

@interface CHNewHopVC : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *charCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIImageView *separatorView;
@property (strong, nonatomic) IBOutlet UIScrollView *myScroolView;
- (IBAction)resignResponder:(id)sender;
- (IBAction)photoTapped:(id)sender;
- (IBAction)submitPressed:(id)sender;

@end
