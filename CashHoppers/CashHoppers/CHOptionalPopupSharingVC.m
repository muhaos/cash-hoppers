//
//  CHOptionalPopupSharingVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHOptionalPopupSharingVC.h"
#import <Social/Social.h>
#import "CHNewHopVC.h"

@interface CHOptionalPopupSharingVC ()

@property (nonatomic, retain) UIViewController* currentController;

@end

@implementation CHOptionalPopupSharingVC
@synthesize nameSharingLabel;

+ (CHOptionalPopupSharingVC*) sharedOptionalPopupVC {
    static CHOptionalPopupSharingVC* instance = nil;
    if (instance == nil) {
        instance = [[CHOptionalPopupSharingVC alloc] initWithNibName:@"CHOptionalPopupSharingVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c withText:(NSString*) text {
    
    self.currentController = c;
    
    switch (self.currentSharingService) {
        case CH_SHARING_SERVICE_FACEBOOK:
            nameSharingLabel.text = @"Sharing to facebook will get you";
            break;
         case CH_SHARING_SERVICE_GOOGLE:
            nameSharingLabel.text = @"Sharing to google plus will get you";
            break;
        case CH_SHARING_SERVICE_TWITTER:
            nameSharingLabel.text = @"Sharing to twitter will get you";
            break;
        default:
            break;
    }
    
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHOptionalPopupVC" reason:@"Loading controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    nameSharingLabel.text = text;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameSharingLabel:nil];
    [super viewDidUnload];
}

- (void)finishedSharing: (BOOL)shared {
    if (shared) {
        
    } else {
    }
}

- (IBAction)okButtonTapped:(id)sender {
    
    switch (self.currentSharingService) {
        case CH_SHARING_SERVICE_GOOGLE: {
            [GPPShare sharedInstance].delegate = self;
            id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
            [shareBuilder setPrefillText:@"CASHHOPPERS"];
            [shareBuilder setURLToShare:[NSURL URLWithString:@"http://www.stti.com.tw/products/Gas_Gun/Non%20Blowback/b/GGH-9502.jpg"]];
            [shareBuilder open];
        }
        break;
       
        case CH_SHARING_SERVICE_FACEBOOK:{
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *tw = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [tw setInitialText:@"Message"];
                [tw addImage:self.imageToShare];
                [self.currentController presentViewController:tw animated:YES completion:nil];
            }
        }
        break;
       
        case CH_SHARING_SERVICE_TWITTER:{
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:@"Message"];
                [tweetSheet addImage:self.imageToShare];
                [self.currentController presentViewController: tweetSheet animated: YES completion: nil];
            }
        }
        break;
        default:
            break;
    }
    
    [self.view removeFromSuperview];
}


- (IBAction)noButtonTapped:(id)sender {
    [self.view removeFromSuperview];
}


@end
