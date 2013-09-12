//
//  CHAdvertisingVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAdvertisingVC.h"
#import "CHAPIClient.h"


@interface CHAdvertisingVC ()

@end

@implementation CHAdvertisingVC
@synthesize reclamaImageView;


static BOOL isAdsShowed = false;


+ (CHAdvertisingVC*) instanceWithAdType:(NSString*)adType andHopID:(NSNumber*) hopID {
    CHAdvertisingVC* instance = [[CHAdvertisingVC alloc] initWithNibName:@"CHAdvertisingVC" bundle:nil];
    [instance loadAdWithAdType:adType andHopID:hopID];
    instance.selfRef = instance;
    instance.view.hidden = YES;
    isAdsShowed = YES;
    
    return instance;
}


- (void) loadAdWithAdType:(NSString*)adType andHopID:(NSNumber*) hopID {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/ads/get_ads.json?api_key=%@&authentication_token=%@&ad_type=%@", CH_API_KEY, aToken, adType];
    
    if (hopID != nil) {
        path = [path stringByAppendingFormat:@"&hop_id=%i", [hopID intValue]];
    }
    
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* ads_json = [JSON objectForKey:@"ad"];
        if (ads_json) {
            self.adsLinkUrlString = [ads_json objectForKey:@"link"];
            self.adsImageUrlString = [ads_json objectForKey:@"picture"];
            self.view.hidden = NO;
            [self setupADS];
        } else {
            [self closeTapped:nil];
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self closeTapped:nil];
        NSLog(@"Can't load url: %@ \n %@", request.URL, [error localizedDescription]);
        
//        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't load url: %@ \n %@", request.URL, [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [av show];
    
    }];
    
    [operation start];
}


- (void) setupADS {
    
    NSURL* imageURL = [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.adsImageUrlString]];
    [self.reclamaImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed: @"spinner.png"]];
}


- (IBAction)adsTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.adsLinkUrlString]];
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
    
    
    
    [super viewDidUnload];
}


+ (BOOL) isShowed {
    return isAdsShowed;
}


+ (void) hide {
    isAdsShowed = NO;
}



- (IBAction)closeTapped:(id)sender {
    
    [CHAdvertisingVC hide];
    
    [self.view removeFromSuperview];
    self.selfRef = nil;
    
    if ([self.ownerController respondsToSelector:@selector(adsClosedTapped)]) {
        [self.ownerController performSelector:@selector(adsClosedTapped)];
    }
}


- (void) dealloc {
    
}

@end
