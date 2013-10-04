//
//  CHAgreeToTermsVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 10/4/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAgreeToTermsVC.h"
#import "CHRegisterVC.h"
#import "CHAdditionalSigninFormVC.h"

@interface CHAgreeToTermsVC ()

@end

@implementation CHAgreeToTermsVC


+ (CHAgreeToTermsVC*) sharedAgreeToTermsVC {
    static CHAgreeToTermsVC* instance = nil;
    if (instance == nil) {
        instance = [[CHAgreeToTermsVC alloc] initWithNibName:@"CHAgreeToTermsVC" bundle:nil];
    }
    return instance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlString = [NSString stringWithFormat:@"http://cashhoppers.com/pages/terms"];
    NSURL *terms = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:terms]];
}


- (void) showInController:(UIViewController*) c {
    [c.view addSubview:self.view];
    self.view.frame = c.view.bounds;
}


- (IBAction)yesButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AgreeToTerms" object:nil];
}


- (IBAction)noButtonTapped:(id)sender
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
