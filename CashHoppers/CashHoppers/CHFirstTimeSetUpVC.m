//
//  CHFirstTimeSetUpVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 11/7/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFirstTimeSetUpVC.h"

@interface CHFirstTimeSetUpVC ()

@property (nonatomic, assign) BOOL isShoweTerms;

@end

@implementation CHFirstTimeSetUpVC
@synthesize isShoweTerms;


+ (CHFirstTimeSetUpVC*) sharedFirstTimeSetUpVC {
    static CHFirstTimeSetUpVC* instance = nil;
    if (instance == nil) {
        instance = [[CHFirstTimeSetUpVC alloc] initWithNibName:@"CHFirstTimeSetUpVC" bundle:nil];
    }
    return instance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        CGRect newFrame = self.view.frame;
        newFrame.origin.y+=20;
        newFrame.size.height +=20;
        self.view.frame = newFrame;
    }

    isShoweTerms = YES;
    [[NSUserDefaults standardUserDefaults] setBool:isShoweTerms forKey:@"ShoweTerms"];
                            
                            

    NSURL *terms = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"]];

    [self.webView loadRequest:[NSURLRequest requestWithURL:terms]];
}


- (void) showInController:(UIViewController*) c {
    [c.view addSubview:self.view];
    self.view.frame = c.view.bounds;
}


- (IBAction)cancelButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
