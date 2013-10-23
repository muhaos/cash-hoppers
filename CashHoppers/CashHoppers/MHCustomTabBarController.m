/*
 * Copyright (c) 2013 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHCustomTabBarController.h"
#import "CHAppDelegate.h"
#import "CHHopChooserVC.h"
#import "CHMessagesManager.h"
#import "CHUserManager.h"


@interface MHCustomTabBarController ()

@property (nonatomic, strong) id arrivedMessagesNotification;
@property (nonatomic, assign) int messagesBadgeCount;
@property (nonatomic, retain) NSTimer *animationTimer;

@end



@implementation MHCustomTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DELEGATE.tabBarController = self;
    [self performSegueWithIdentifier:@"homeScreen" sender:nil];

    [self setNewMessagesBadge:0];
    self.arrivedMessagesNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_NEW_MESSAGES_ARRIVED object:nil queue:nil usingBlock:^(NSNotification* note) {
        NSArray* messages = note.object;
        
        for (int i = 0; i < messages.count; i++) {
            CHMessage *ms = [messages objectAtIndex:i];
            if (![ms.sender_id isEqual:[CHUserManager instance].currentUser.identifier]) {
                self.messagesBadgeCount++;
            }
        }
        
        [self setNewMessagesBadge:self.messagesBadgeCount];
    }];
}


- (void) setNewMessagesBadge:(int) count {
    self.messagesBadgeCount = count;
    if (count <= 0) {
        self.messagesIndicatorImage.hidden = YES;
        self.messagesIndicatorLabel.hidden = YES;
        [self stopAnimationTimer];
    } else {
        self.messagesIndicatorImage.hidden = NO;
        self.messagesIndicatorLabel.hidden = NO;
        self.messagesIndicatorLabel.text = [NSString stringWithFormat:@"%i", count];

        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.4f
                                                        target:self
                                                      selector:@selector(animationNotification)
                                                      userInfo:nil
                                                       repeats:YES];
    }
}


-(void) animationNotification
{
    [UIView animateWithDuration:.5f delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            CGRect f1 = self.messagesIndicatorImage.frame;
                            CGRect f2 = self.messagesIndicatorLabel.frame;
                            f1.origin.y -= 5;
                            f2.origin.y -= 5;
                            self.messagesIndicatorImage.frame = f1;
                            self.messagesIndicatorLabel.frame = f2;
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:.5f delay:0.2f
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  CGRect f1 = self.messagesIndicatorImage.frame;
                                                  CGRect f2 = self.messagesIndicatorLabel.frame;
                                                  f1.origin.y += 5;
                                                  f2.origin.y += 5;
                                                  self.messagesIndicatorImage.frame = f1;
                                                  self.messagesIndicatorLabel.frame = f2;
                                              }
                                              completion:nil];
                         }];
}


-(void) stopAnimationTimer
{
    if ([self.animationTimer isValid]) {
        [self.animationTimer invalidate];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.presentingViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.presentingViewController endAppearanceTransition];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    if (self.childViewControllers.count < 1) {
//        //[self performSegueWithIdentifier:@"homeScreen" sender:[_buttonView.subviews objectAtIndex:1]];
//    }
}


#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UIViewController *vc  in self.childViewControllers) {
        [vc.view setFrame:self.container.bounds];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    for (UIView *subview in _buttonView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [((UIButton *)subview) setSelected:NO];
        }
    }
        
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    self.currentIdentifier = segue.identifier;
    self.currentViewController = segue.destinationViewController;

    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.currentIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        if ([self.currentViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)self.currentViewController popToRootViewControllerAnimated:NO];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    for (UIViewController *vc in self.childViewControllers) {
        if (![vc isEqual:self.currentViewController]) {
            [vc willMoveToParentViewController:nil];
            [vc removeFromParentViewController];
        }
    }
}


- (IBAction)hopChooseTapped:(id)sender {
    [[CHHopChooserVC sharedHopChooserVC] showInController:self.container];
}


- (IBAction)friendsFeedTapped:(id)sender {
    DELEGATE.needOpenFriendsFeed = YES;
    [self performSegueWithIdentifier:@"homeScreen" sender:nil];
}


- (IBAction)pictureTapped:(id)sender {
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@""];
}

@end
