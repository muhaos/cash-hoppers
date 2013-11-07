//
//  CHTermsOfUseVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 11/6/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHTermsOfUseVC.h"

@interface CHTermsOfUseVC ()

@end

@implementation CHTermsOfUseVC
@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];

    NSURL *link = [NSURL URLWithString:@"http://cashhoppers.com/pages/terms"];
    [webView loadRequest:[NSURLRequest requestWithURL:link]];
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


-(void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setWebView:nil];
}

@end
