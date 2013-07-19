//
//  CHOptionalPopupSharingVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHOptionalPopupSharingVC.h"

@interface CHOptionalPopupSharingVC ()

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


- (IBAction)okButtonTapped:(id)sender {
    [self.view removeFromSuperview];
}


- (IBAction)noButtonTapped:(id)sender {
    [self.view removeFromSuperview];
}

@end
