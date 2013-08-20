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
#import "GTLPlusPerson.h"


@interface CHStartVC ()
{
    __block  NSMutableDictionary *dict;
}

@property (retain, nonatomic) GPPSignIn *signIn;
@property (strong, nonatomic) FBProfilePictureView *profileImage;

- (IBAction)loginWithFBTapped:(id)sender;
- (IBAction)loginWithTwitterTapped:(id)sender;
- (IBAction)loginGPlusTapped:(id)sender;

@end

@implementation CHStartVC
@synthesize signIn, profileImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_gradient"]];
    self.view.backgroundColor = background;
    
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, 
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
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"mW5vfqMKEx1HGME7OeGCg" andSecret:@"RjiYj98WZSjKBbHn9r3hGYvMfptYPp5pQCP8h4gNH5A"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    NSString *username = [[FHSTwitterEngine sharedEngine]loggedInUsername];
    if (username.length > 0) {
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}


//for google+
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *)error {
    if(!error) {}
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


-(void)userGooglePlusDetails {
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:signIn.authentication];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
//                    GTMLoggerError(@"Error: %@", error);
                } else {
                    NSString *description = [NSString stringWithFormat:
                                             @" display name: %@\n  nikname %@\n  image: %@\n  email: %@\n  identifier: %@\n ", person.displayName, person.nickname,person.image, signIn.userEmail, person.identifier];
                    NSLog(@"%@", description);
                }
            }
     ];
}


////for fb
- (IBAction)loginWithFBTapped:(id)sender {
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
    } else {
    }
}


- (void)userFacebookDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
                 NSLog(@"%@", user.first_name);
                 NSLog(@"%@", user.last_name);
                 NSLog(@"%@", user.username);
                 NSLog(@"%@", self.profileImage.profileID = user.id);
             }
         }];
    }
}

//for twitter
- (IBAction)loginWithTwitterTapped:(id)sender {
    [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
    }];
}


- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}


- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedAccessHTTPBody"];
}


- (void)userTwitterDetails {
    dict = nil;
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString *username = [[FHSTwitterEngine sharedEngine]loggedInUsername];
            dict = [[FHSTwitterEngine sharedEngine]getUserSettings];
            UIImage *img = [[FHSTwitterEngine sharedEngine] getProfileImageForUsername:username andSize:FHSTwitterEngineImageSizeNormal];
            NSLog(@"%@", [dict objectForKey:@"screen_name"]);
            NSLog(@"%@", img);
            dispatch_sync(GCDMainThread, ^{
                @autoreleasepool {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            });
        }
    });    
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
