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
#import <FacebookSDK/FacebookSDK.h>
#import "GPPSignIn.h"

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



//-(void) dateForFb {
//    
//    CHAppDelegate *appDelegate = [[CHAppDelegate alloc] init];
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



////for fb
- (IBAction)loginWithFBTapped:(id)sender {
    CHAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

//- (void)populateUserDetails
//{
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           *NSDictionary&lt;FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 self.userNameLabel.text = user.name;
//                 self.userProfileImage.profileID = user.id;
//             }
//         }];
//    }
//}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
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


- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
