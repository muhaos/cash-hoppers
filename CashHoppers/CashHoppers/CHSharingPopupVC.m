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
    // Do any additional setup after loading the view from its nib.
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
        [tw setInitialText:@"Message"];
        [tw addImage:self.imageToShare];
        tw.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone) {
                [[CHHopsManager instance] notifiServerOfSharingWithService:@"facebook" andHopTaskID:self.hopTaskID];
            }
        };
        [self.currentController presentViewController:tw animated:YES completion:nil];
    }

//    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
//    [action setObject:@"https://apps.notrepro.net/fbsdktoolkit/objects/book/Snow-Crash.html"forKey:@"book"];
//    
//    FBOpenGraphActionShareDialogParams* params = [[FBOpenGraphActionShareDialogParams alloc]init];
//    params.actionType = @"books.reads";
//    params.action = action;
//    params.previewPropertyName = @"book";
//    
//    // Show the Share dialog if available
//    if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
//        
//        [FBDialogs presentShareDialogWithOpenGraphAction:[params action]
//                                              actionType:[params actionType]
//                                     previewPropertyName:[params previewPropertyName]
//                                                 handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                                     // handle response or error
//                                                 }];
//        
//    }
//    // If the Facebook app isn't available, show the Feed dialog as a fallback
//    else {
//        NSDictionary* params = @{@"name": @"Snow Crash",
//                                 @"caption": @"Classic cyberpunk",
//                                 @"description": @"In reality, Hiro Protagonist delivers pizza for Uncle Enzo's CosoNostra Pizza Inc., but in the Metaverse he's a warrior prince. ",
//                                 @"link": @"https://apps.notrepro.net/fbsdktoolkit/objects/book/Snow-Crash.html",
//                                 @"image": @"http://upload.wikimedia.org/wikipedia/en/d/d5/Snowcrash.jpg"};
//        
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      // handle response or error
//                                                  }];
//    }
}

- (IBAction)gPlusButTapped:(id)sender {
    
    [GPPShare sharedInstance].delegate = self;
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    [shareBuilder setPrefillText:@"CASHHOPPERS"];
    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://www.stti.com.tw/products/Gas_Gun/Non%20Blowback/b/GGH-9502.jpg"]];
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
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.view removeFromSuperview];   
}

@end
