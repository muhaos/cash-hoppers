//
//  CHAdvertisingVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAdvertisingVC.h"

@interface CHAdvertisingVC ()

@end

@implementation CHAdvertisingVC
@synthesize headerLabel,reclamaImageView,bottomHeaderLabel,bottomLabel;


+ (CHAdvertisingVC*) sharedAdverticingVC {
    static CHAdvertisingVC* instance = nil;
    if (instance == nil) {
        instance = [[CHAdvertisingVC alloc] initWithNibName:@"CHAdvertisingVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c
          withHeaderLabel:(NSString*) header
                withImage:(UIImage*) image
    withBottomHeaderLabel:(NSString*) bottomHeader
          withBottomLabel:(NSString*)bottom; {
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHAdvertisingVC" reason:@"Reclama already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    self.view.frame = c.view.bounds;
    self.headerLabel.text = header;
    self.reclamaImageView.image = image;
    self.bottomHeaderLabel.text = bottomHeader;
    self.bottomLabel.text = bottom;
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
    [self setHeaderLabel:nil];
    [self setBottomHeaderLabel:nil];
    [self setBottomLabel:nil];
    [super viewDidUnload];
}


- (IBAction)closeTapped:(id)sender {
       [self.view removeFromSuperview];
}


@end
