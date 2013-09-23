//
//  CHSharingPopupVC.m
//  CashHoppers
//
//  Created by Eugene on 01.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHSharingPopupVC.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CHHopsManager.h"
#import "CHNewHopVC.h"

@interface CHSharingPopupVC ()

@end

@implementation CHSharingPopupVC

+ (CHSharingPopupVC*) instance {
    static CHSharingPopupVC* instance = nil;
    if (instance == nil) {
        instance = [[CHSharingPopupVC alloc] initWithNibName:@"CHSharingPopupVC" bundle:nil];
    }
    return instance;
}

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
    self.logoToShare = [UIImage imageNamed:@"Icon-72@2x.png"];
}


- (void) showInController:(UIViewController*)controller{
    
    _currentController = controller;
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHSharingPopupVC" reason:@"Loading controller already showed!" userInfo:nil];
    }
    [controller.view addSubview:self.view];
    

}

- (void) hide{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)finishedSharing: (BOOL)shared {
    if (shared) {
        [[CHHopsManager instance] notifiServerOfSharingWithService:@"google" andHopTaskID:self.hopTaskID];
        NSLog(@"User successfully shared!");
    } else {
        NSLog(@"User didn't share.");
    }
}


- (IBAction)facebookButTapped:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *tw = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [tw setInitialText:@" "];
        [tw addImage:self.imageToShare];
        [tw addImage:self.logoToShare];

        tw.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                [[CHHopsManager instance] notifiServerOfSharingWithService:@"facebook" andHopTaskID:self.hopTaskID];
            }
        };
        [self.currentController presentViewController:tw animated:YES completion:nil];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No Facebook Account"
                                                     message:@"There are no Facebook accounts configured. You can add or create Facebook account in Settings."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }

}

- (IBAction)gPlusButTapped:(id)sender {
    [GPPShare sharedInstance].delegate = self;
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    [shareBuilder setPrefillText:@"CASHHOPPERS"];
    [shareBuilder setURLToShare:self.imageToShareURL];
    [shareBuilder open];
    
}

- (IBAction)twitterButTapped:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Message"];
        [tweetSheet addImage:self.imageToShare];
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                [[CHHopsManager instance] notifiServerOfSharingWithService:@"twitter" andHopTaskID:self.hopTaskID];
            }
        };

        [self.currentController presentViewController: tweetSheet animated: YES completion: nil];
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No Twitter Account"
                                                      message:@"There are no Twitter accounts configured. You can add or create Twitter account in Settings."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseSharingPopup" object:nil];
}

@end
