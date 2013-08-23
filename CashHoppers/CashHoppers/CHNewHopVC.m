//
//  CHNewHopVC.m
//  CashHoppers
//
//  Created by Eugene on 24.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHNewHopVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "CHMenuSlidingVC.h"
#import <Social/Social.h>
#import "GPPShare.h"
#import "GPPSignIn.h"
#import "CHStartVC.h"
#import "CHOptionalPopupSharingVC.h"
#import "CHLoadingVC.h"
#import "CHHopsManager.h"
#import "CHSharingPopupVC.h"
#import "AFNetworking.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface CHNewHopVC ()
@property (assign) BOOL takePhoto;
@end

@implementation CHNewHopVC
@synthesize menuButton, winnterButton, photoImView, takePhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    takePhoto = NO;
    
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 3;
    _textView.layer.borderColor = CH_GRAY_COLOR.CGColor;
    _textView.text = @"Leave a comment...";
    _textView.textColor = [UIColor lightGrayColor];
    
    _charCountLabel.layer.cornerRadius = 3;
    _charCountLabel.backgroundColor = CH_GRAY_COLOR;
    
    photoImView.layer.cornerRadius = 3;
    
    UIImage *submitBgIm = [[UIImage imageNamed:@"yellow_button"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_submitButton setBackgroundImage:submitBgIm forState:UIControlStateNormal];
    
    _separatorView.backgroundColor = CH_GRAY_COLOR;
	// Do any additional setup after loading the view.
    
    _myScroolView.frame = (CGRect){_myScroolView.frame.origin, CGSizeMake(320, 502)};
    _myScroolView.contentSize = CGSizeMake(320, 504);
    
//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[CHMenuSlidingVC class]]) {
//        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
//    }
    
 //   [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [menuButton addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.submitButton.hidden = [self.currentHopTask.completed boolValue];
    if ([self.currentHopTask.completed boolValue] == YES) {
        self.sharingView.hidden = NO;
    }else {
        self.sharingView.hidden = YES;
    }
    self.hopTitleLabel.text = [NSString stringWithFormat:@"%@   %@", self.currentHopTask.hop.name, [self.currentHopTask.hop dateString]];
    [self.taskLogoImageView setImageWithURL:[self.currentHopTask logoURL]];
    
    [self setHopTaskName:[NSString stringWithFormat:@"%@: %@", self.currentHopTask.hop.name, self.currentHopTask.text] withBoldString:self.currentHopTask.hop.name];
}


- (void) setHopTaskName:(NSString*) wholeStr withBoldString:(NSString*) boldPartStr {
    
    NSDictionary *boldAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans-Bold" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]};
    NSDictionary *normAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]};
    
    NSMutableAttributedString* mStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    
    NSInteger str_length = [wholeStr length];
    
    [mStr setAttributes:normAttribs range:NSMakeRange(0, str_length)];
    if (boldPartStr != nil) {
        [mStr setAttributes:boldAttribs range:[wholeStr rangeOfString:boldPartStr]];
    }
    
    self.hopTaskTitleLabel.attributedText = mStr;
}



-(void)viewWillDisappear:(BOOL)animated {
 //   [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}


#pragma mark - textView delegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Leave a comment..."]){
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor];
    }
    [self shiftViewUp];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    NSInteger count = CH_NUMBER_OF_CHARACTERS-textView.text.length;
    _charCountLabel.text = [NSString stringWithFormat:@"%d", count];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        textView.text = @"Leave a comment...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [self shiftViewToDefault];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

#pragma mark - shift view up/down methods

-(void)shiftViewUp{
    CGRect newFrame = self.view.frame;
    CGSize keybSize = [self keyboardSize];
    newFrame.origin.y = -((_textView.frame.origin.y+_textView.frame.size.height) -(self.view.frame.size.height - keybSize.height)+5);
    [UIView animateWithDuration:.2 animations:^{
        self.view.frame = newFrame;
    }];
    
}

-(void)shiftViewToDefault{
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = 0;
    [UIView animateWithDuration:.2 animations:^{
        self.view.frame = newFrame;
    }];
    
}


-(CGSize)keyboardSize{
    UIInterfaceOrientation *orient = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        if(UIInterfaceOrientationIsPortrait(orient)){
            return CGSizeMake(320, 216);
        }else{
            return CGSizeMake(162, 480);
        }
    }else{
        if(UIInterfaceOrientationIsPortrait(orient)){
            return CGSizeMake(768, 220);
        }else{
            return CGSizeMake(1024, 370);
        }
        
    }
    
    return CGSizeZero;
}


#pragma mark - ibactions

- (IBAction)shareButtonTapped:(id)sender
{
    [self adsClosedTapped];
}

- (IBAction)resignResponder:(id)sender {
    
    [_textView resignFirstResponder];
    
}

- (IBAction)photoTapped:(id)sender {
    takePhoto = YES;
    UIImagePickerController *poc = [[UIImagePickerController alloc] init];
    [poc setTitle:@"Take a photo."];
    [poc setDelegate:self];
#if TARGET_IPHONE_SIMULATOR
    [poc setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
#elif TARGET_OS_IPHONE
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [poc setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [poc setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
#else
#endif
    
    [self presentViewController:poc animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@""];
}

#pragma mark - imagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
   	photoImView.image = chosenImage;
    
}


- (IBAction)submitPressed:(id)sender {
    [[CHLoadingVC sharedLoadingVC] showInController:self.view.window.rootViewController withText:@"Processing..."];
    if (takePhoto == YES) {
        [[CHHopsManager instance] completeHopTask:self.currentHopTask withPhoto:photoImView.image comment:_textView.text completionHandler:^(BOOL success) {
            if (success) {
                self.currentHopTask.completed = @YES;
                [self showAdsWithType:@"ROFL" andHopID:self.currentHopTask.hop.identifier];
                [self saveImageCopyToGalery];
                self.submitButton.hidden = YES;
                [self adsClosedTapped];
            }
            [[CHLoadingVC sharedLoadingVC] hide];
        }];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Photo is required !"
                                                     message:@"Please, take a photo"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        [[CHLoadingVC sharedLoadingVC] hide]; 
    }
}


- (void) saveImageCopyToGalery {
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library saveImage:photoImView.image toAlbum:@"CASHHOPPERS" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
}


- (void) adsClosedTapped {
    [CHSharingPopupVC instance].hopTaskID = self.currentHopTask.identifier;
    [CHSharingPopupVC instance].imageToShare = self.photoImView.image;
    [[CHSharingPopupVC instance]showInController:self.parentViewController.parentViewController];
}


- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (IBAction)shareWithFacebookTapped:(id)sender {
    [CHOptionalPopupSharingVC sharedOptionalPopupVC].imageToShare = self.photoImView.image;
    [CHOptionalPopupSharingVC sharedOptionalPopupVC].currentSharingService = CH_SHARING_SERVICE_FACEBOOK;
    [[CHOptionalPopupSharingVC sharedOptionalPopupVC] showInController:self withText:@"Sharing to facebook will get you"];
}


- (IBAction)shareWithTwitterTapped:(id)sender {
    [CHOptionalPopupSharingVC sharedOptionalPopupVC].imageToShare = self.photoImView.image;
    [CHOptionalPopupSharingVC sharedOptionalPopupVC].currentSharingService = CH_SHARING_SERVICE_TWITTER;
    [[CHOptionalPopupSharingVC sharedOptionalPopupVC] showInController:self withText:@"Sharing to twitter will get you"];
    
//    [tweeterEngine sendUpdate:@"cashhopppers"];
}


- (IBAction)shareWithGPlusTapped:(id)sender {
    [CHOptionalPopupSharingVC sharedOptionalPopupVC].imageToShare = self.photoImView.image;
    [CHOptionalPopupSharingVC sharedOptionalPopupVC].currentSharingService = CH_SHARING_SERVICE_GOOGLE;
    [[CHOptionalPopupSharingVC sharedOptionalPopupVC] showInController:self withText:@"Sharing to google plus will get you"];
}


-(BOOL)resignWinnerButton
{
    return  winnterButton.hidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [self setCharCountLabel:nil];
    [self setPhotoImView:nil];
    [self setSubmitButton:nil];
    [self setSeparatorView:nil];
    [self setMyScroolView:nil];
    [self setMenuButton:nil];
    [self setWinnterButton:nil];
    [self setSharingView:nil];
    [super viewDidUnload];
}

@end
