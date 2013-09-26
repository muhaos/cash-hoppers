//
//  CHWinnerVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHWinnerVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CHHopsManager.h"
#import "AFNetworking.h"
#import "CHAPIClient.h"


@interface CHWinnerVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHWinnerVC
@synthesize photoImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    self.nameLabel.text = @"";

    self.dateLabel.hidden = YES;
    self.contactAsTextView.hidden = YES;
    self.photoImageView.image = nil;
    
    photoImageView.layer.cornerRadius = 70;
    photoImageView.clipsToBounds = YES;
    
    [[CHHopsManager instance] loadYesterdayWinnerWithCompletionHandler:^(NSDictionary* winnerDic) {

        if (winnerDic) {
            self.dateLabel.text = [NSString stringWithFormat:@"%@ ($%i JACKPOT)", [winnerDic objectForKey:@"hop_name"], [[winnerDic objectForKey:@"cost"] intValue]];
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [winnerDic objectForKey:@"winners_first_name"], [winnerDic objectForKey:@"winners_last_name"]];
            
            
            NSString *urlStr  = [CHBaseModel safeStringFrom:[winnerDic objectForKey:@"winners_avatar"] defaultValue:nil] ;
            
            NSURL* avatarUrl = [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:urlStr]];
            
           [photoImageView setImageWithURL:avatarUrl];
            
            self.dateLabel.hidden = NO;
            self.contactAsTextView.hidden = NO;
            
        } else {
            self.nameLabel.text = @"There was no Daily HOP winner yesterday. Will you be today’s winner?";
        }
    }];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showAdsWithType:@"RPOU" andHopID:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setNameLabel:nil];
    [self setDescrLabel:nil];
    [self setPhotoImageView:nil];
    [super viewDidUnload];
}
@end
