//
//  CHAppDelegate.m
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAppDelegate.h"
#import "MHCustomTabBarController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CHStartVC.h"
#import "GPPDeepLink.h"
#import "GPPURLHandler.h"
#import "CHMenuSlidingVC.h"
#import "MFSideMenuContainerViewController.h"

@implementation CHAppDelegate
@synthesize homeScreenVC, navController;
@synthesize menuContainerVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Override point for customization after application launch.
    
   

//    return YES;
    /*
    self.homeScreenVC = [[CHHomeScreenViewController alloc]
                               initWithNibName:@"CHHomeSreenVC" bundle:nil];
    self.navController = [[UINavigationController alloc]
                          initWithRootViewController:self.homeScreenVC];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    */
    
    [self setupApperences];
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];

    self.menuContainerVC = [storyboard instantiateViewControllerWithIdentifier:@"MFSideMenuContainerViewController"];
    UIViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    CHMenuSlidingVC *leftMenu = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    
    [menuContainerVC setCenterViewController:tabBarVC];
    [menuContainerVC setLeftMenuViewController:leftMenu];
    
    //self.tabBarController = [[[[self window]rootViewController]storyboard]instantiateViewControllerWithIdentifier:@"tabBar"];
    NSString *a_token = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    //    NSLog(@"token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"]);
    if(a_token){
        self.window.rootViewController = self.menuContainerVC;
    }

    [GPPSignIn sharedInstance].clientID = kClientId;
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];

    
    
    return YES;

}


- (void) setupApperences {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_background"] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - Facebook SDK
- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[CHStartVC class]]) {
        CHStartVC* startVC = [[CHStartVC alloc] initWithNibName:@"CHStartVC"
                                                      bundle:nil];
        [topViewController presentModalViewController:startVC animated:NO];
    } else {
        CHStartVC* startVC =
        (CHStartVC*)modalViewController;
        [startVC loginFailed];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController modalViewController]
                 isKindOfClass:[CHStartVC class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession sessionOpenWithPermissions:nil
                        completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
                            [self sessionStateChanged:session
                                                state:state
                                                error:error];}];
}


#pragma mark - Google+ SDK
- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)switchViewTo:(enum CHView)view{
    
    UIButton *but =  (UIButton*)[_tabBarController.buttonView.subviews objectAtIndex:view];
    [but sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    //    NSString *segueID;
    //    switch (view) {
    //        case CHHome:{
    //            segueID = @"homeScreen";
    //            break;
    //        }
    //        case CHFeed:{
    //            segueID = @"feed";
    //            break;
    //        }
    //        case CHMessage:{
    //            segueID = @"";
    //            break;
    //        }
    //        case CHNewHop:{
    //            segueID = @"newHop";
    //            break;
    //        }
    //        case CHPicture:{
    //            segueID = @"";
    //            break;
    //        }
    //        default:
    //            break;
    //    }
    //    NSLog(@"id =%@",segueID);
    //    [self performSegueWithIdentifier:segueID sender:[_buttonView.subviews objectAtIndex:0]];
}

@end
