//
//  CHHelpVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHelpVC.h"

@interface CHHelpVC ()

@end

@implementation CHHelpVC
@synthesize contentWebView, url;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];

    NSURL *howToPlay = [NSURL URLWithString:url];
    [contentWebView loadRequest:[NSURLRequest requestWithURL:howToPlay]];
}


- (void) backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)viewDidUnload {
    [self setContentWebView:nil];
    [super viewDidUnload];
}

@end
