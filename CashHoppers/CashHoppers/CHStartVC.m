//
//  CHStartVC.m
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHStartVC.h"
#import "CHAppDelegate.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "GTLPlusConstants.h"


@interface CHStartVC ()

- (IBAction)loginWithFBTapped:(id)sender;
- (IBAction)loginWithTwitterTapped:(id)sender;

@end

@implementation CHStartVC
@synthesize loginWithGoogleButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gradient"]];
    self.view.backgroundColor = background;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // определяется в файле GTLPlusConstants.h
                     nil];
    signIn.delegate = self;
    [signIn trySilentAuthentication];
}


//for google+
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
}



//for twitter




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginWithFBTapped:(id)sender {
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}


- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
}


- (IBAction)loginWithTwitterTapped:(id)sender {
}

@end
