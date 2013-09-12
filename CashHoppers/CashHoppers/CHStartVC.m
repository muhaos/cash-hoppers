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
#import "CHAdditionalSigninFormVC.h"
#import <QuartzCore/QuartzCore.h>


@interface CHStartVC ()<FBWebDialogsDelegate>

@property (retain, nonatomic) GPPSignIn *signIn;
@property (retain, nonatomic) GTLPlusPerson *personData;
@property (strong, nonatomic) FBProfilePictureView *profileImage;
@property (retain, nonatomic) UIImage *imageForTwitter;
@property (retain, nonatomic) NSString *idForTwitter;
@property (retain, nonatomic) NSMutableDictionary *dict;
@property (retain, nonatomic) NSString *socialNetwork;

@property (retain, nonatomic) NSString *idFacebook;
@property (retain, nonatomic) NSString *firstNameFacebook;
@property (retain, nonatomic) NSString *lastNameFacebook;
@property (retain, nonatomic) NSString *usernameFacebook;

- (IBAction)loginWithFBTapped:(id)sender;
- (IBAction)loginWithTwitterTapped:(id)sender;
- (IBAction)loginGPlusTapped:(id)sender;

@end

@implementation CHStartVC
@synthesize signIn, profileImage, imageForTwitter, idForTwitter, dict, socialNetwork, personData, idFacebook, firstNameFacebook, lastNameFacebook, usernameFacebook;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DELEGATE.startVC = self;
    
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
    if(!error) {
        [self userGooglePlusDetails];
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
    CHAppDelegate * appDelegate = (CHAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (appDelegate.netStatus == NotReachable) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No internet connection!"
                                                     message:@""
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else {
        [signIn authenticate];
    }
}


-(void)userGooglePlusDetails {
    socialNetwork = @"gplus";
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
                    personData = person;
                    [self performSegueWithIdentifier:@"additional_signin" sender:self];
                }
            }
     ];
}


////for fb
static BOOL needLoginWithFacebook = NO;
- (IBAction)loginWithFBTapped:(id)sender {
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.netStatus == NotReachable) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No internet connection!"
                                                     message:@""
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else {
        needLoginWithFacebook = YES;

        self.needOpenFacebookAdditionalPage = YES;
        
        if (FBSession.activeSession.isOpen) {
            if (FBSession.activeSession.state == FBSessionStateClosedLoginFailed){
            } else {
                [self userFacebookDetails];
            }
        } else {
            appDelegate.loggedInSession = [[FBSession alloc] init];
            [appDelegate.loggedInSession openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error){
                
            }];
        }
    }
}


- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        if (needLoginWithFacebook) {
            [self userFacebookDetails];
            needLoginWithFacebook = NO;
        }
    } else {
    }
}


- (void)userFacebookDetails
{
    self.needOpenFacebookAdditionalPage = NO;
    socialNetwork = @"facebook";
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 idFacebook = user.id;
                 firstNameFacebook = user.first_name;
                 lastNameFacebook = user.last_name;
                 usernameFacebook = user.username;
                 profileImage.profileID = user.id;
                 [self performSegueWithIdentifier:@"additional_signin" sender:self];
             }
         }];
    }
}

//for twitter
- (IBAction)loginWithTwitterTapped:(id)sender {
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.netStatus == NotReachable) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No internet connection!"
                                                     message:@""
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else {
        static CHStartVC* selfRef;
        selfRef = self;
        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
            NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
            [selfRef userTwitterDetails];
        }];
    }
}


- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}


- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedAccessHTTPBody"];
}


- (void)userTwitterDetails {
    socialNetwork = @"twitter";
    dict = nil;
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString *username = [[FHSTwitterEngine sharedEngine]loggedInUsername];
            NSString *user_identifier = [[FHSTwitterEngine sharedEngine]loggedInID];
            dict = [[FHSTwitterEngine sharedEngine]getUserSettings];
            imageForTwitter = [[FHSTwitterEngine sharedEngine] getProfileImageForUsername:username andSize:FHSTwitterEngineImageSizeNormal];
            idForTwitter = user_identifier;
            dispatch_sync(GCDMainThread, ^{
                @autoreleasepool {
                    [self performSegueWithIdentifier:@"additional_signin" sender:self];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
            });
        }
    });    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"additional_signin"]) {
        CHAdditionalSigninFormVC* vc = segue.destinationViewController;
        
        if ([socialNetwork isEqualToString:@"twitter"])
        {
            vc.screenNameUser = [dict objectForKey:@"screen_name"];
            vc.imageUser = imageForTwitter;
            vc.idUser = idForTwitter;
            vc.provider = @"twitter";
        }
       
        if ([socialNetwork isEqualToString:@"facebook"]) {
            vc.idUser = idFacebook;
            NSString *string = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", idFacebook];
            NSURL *imageURL = [NSURL URLWithString:string];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            vc.imageUser = [UIImage imageWithData:imageData];
            vc.firstNameUser = firstNameFacebook;
            vc.lastNameUser = lastNameFacebook;
            vc.screenNameUser = usernameFacebook;
            vc.provider = @"facebook";
        }
       
        if ([socialNetwork isEqualToString:@"gplus"])
        {
            NSURL *imageURL = [NSURL URLWithString:personData.image.url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            vc.imageUser = [UIImage imageWithData:imageData];
            vc.screenNameUser = personData.nickname;
            vc.idUser = personData.identifier;
            vc.firstNameUser = personData.name.formatted;
            vc.emailUser = signIn.userEmail;
            vc.provider = @"google";
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
