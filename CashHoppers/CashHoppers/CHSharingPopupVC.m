//
//  CHSharingPopupVC.m
//  CashHoppers
//
//  Created by Eugene on 01.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHSharingPopupVC.h"
#import <Social/Social.h>

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

- (IBAction)facebookButTapped:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *tw = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [tw setInitialText:@"Message"];
        [tw addImage:self.imageToShare];
        [self.currentController presentViewController:tw animated:YES completion:nil];
    }

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
        [self.currentController presentViewController: tweetSheet animated: YES completion: nil];
    }
}

@end
