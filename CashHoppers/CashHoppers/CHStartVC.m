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
#import "GTLServicePlus.h"
#import "GTLQueryPlus.h"
#import "GPPSignIn.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

SA_OAuthTwitterEngine	*tweeterEngine;

@interface CHStartVC ()

@property (retain, nonatomic) GPPSignIn *signIn;

- (IBAction)loginWithFBTapped:(id)sender;
- (IBAction)loginWithTwitterTapped:(id)sender;
- (IBAction)loginGPlusTapped:(id)sender;

@end

@implementation CHStartVC
@synthesize signIn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gradient"]];
    self.view.backgroundColor = background;
    
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // определяется в файле GTLPlusConstants.h
                     nil];
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
    [signIn trySilentAuthentication];
    
    // Register for notifications on FB session state changes
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    [appDelegate openSessionWithAllowLoginUI:NO];
}


//for google+

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *)error {
    if(!error) {
        // Получим адрес электронной почты.
 //       NSLog(@"%@", signIn.authentication.userEmail);
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // Пользователь вышел и отключился.
        // Удалим данные пользователя в соответствии с Условиями использования Google+.
    }
}


- (IBAction)loginGPlusTapped:(id)sender {
    [signIn authenticate];
}


//-(void)dateForGp {
//    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
//    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
//    plusService.retryEnabled = YES;
//    [plusService setAuthorizer:appDelegate.authentication];
//    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
//    
//    [plusService executeQuery:query
//            completionHandler:^(GTLServiceTicket *ticket,
//                                GTLPlusPerson *person,
//                                NSError *error) {
//                if (error) {
//                    GTMLoggerError(@"Error: %@", error);
//                } else {
//                    // Извлечем отображаемое имя и содержание раздела "Обо мне"
//                    [person retain];
//                    NSString *description = [NSString stringWithFormat:
//                                             @"%@\n%@", person.displayName,
//                                             person.aboutMe];
//                }
//            }];
//}


////for fb
- (IBAction)loginWithFBTapped:(id)sender {
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
    } else {
      
    }
}


//for twitter

- (IBAction)loginWithTwitterTapped:(id)sender {
    if (tweeterEngine) return;
    tweeterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    tweeterEngine.consumerKey = kOAuthConsumerKey;
    tweeterEngine.consumerSecret = kOAuthConsumerSecret;
    
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:tweeterEngine delegate:self];
    if (controller) {
        [self presentModalViewController:controller animated:YES];
    }
    [self presentViewController:DELEGATE.menuContainerVC animated:YES completion:nil];
}

#pragma mark - Twitter
#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void) twitterOAuthConnectionFailedWithData: (NSData *) data {
	NSLog(@"twitterOAuthConnectionFailedWithData");
}


- (void)requestSucceeded:(NSString *)connectionIdentifier {
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)",
          connectionIdentifier,
          [error localizedDescription],
          [error userInfo]);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
