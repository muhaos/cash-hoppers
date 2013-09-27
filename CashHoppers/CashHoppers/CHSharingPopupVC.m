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
    NSString *bonusPointsStr;
    if (self.bonusPointsCount == nil) {
        bonusPointsStr= [[NSString alloc] initWithFormat:@"For 0 more points"];
    }else{
        bonusPointsStr = [[NSString alloc] initWithFormat:@"For %@ more points", self.bonusPointsCount];
    }
    self.bonusPointsLabel.text = bonusPointsStr;
    
    self.facebookButton.frame = CGRectMake(38, 259, 60, 60);
    self.twitterButton.frame = CGRectMake(134, 259, 60, 60);
    self.googleButton.frame = CGRectMake(231, 259, 60, 60);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        CGRect newFrame = self.view.frame;
        newFrame.origin.y+=20;
        newFrame.size.height -=20;
        self.view.frame = newFrame;
    }
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
    NSString* shareString = [NSString stringWithFormat:@"%@: %@",self.curentHop, self.commentToHopTask];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *tw = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [tw setInitialText:shareString];
        [tw addImage:self.imageToShare];
        [tw addURL:[NSURL URLWithString:@"http://ec2-54-227-42-108.compute-1.amazonaws.com/"]];

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

- (void)viewDidUnload {
    [self setBonusPointsLabel:nil];
    [super viewDidUnload];
}
@end
