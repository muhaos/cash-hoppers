//
//  CHAddFriendsCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendsCell.h"
#import "CHStartVC.h"
#import "Facebook.h"
#import "FacebookRequestController.h"
#import "CHAddFriendsSocialNetworksVC.h"

@implementation CHAddFriendsCell
@synthesize data, requestPath;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setData:(NSDictionary *)dictionary {
    CHAddFriendsSocialNetworksVC* vc = [[CHAddFriendsSocialNetworksVC alloc] init];
    
	[data release];
	data = [dictionary retain];
    
    switch (vc.currentService) {
        case CH_SERVICE_FACEBOOK:
            self.nameLabel.text = [data objectForKey:@"name"];
            break;
        case CH_SERVICE_TWITTER:
            self.nameLabel.text = [data objectForKey:@"screen_name"];
            break;
        default:
            break;
    }

    self.photoImageView.image = nil;
	[self setNeedsLayout];
    
    switch (vc.currentService) {
        case CH_SERVICE_FACEBOOK:
            self.requestPath = [NSString stringWithFormat:@"%@/picture", [data objectForKey:@"id"]];
            [[FacebookRequestController sharedRequestController] enqueueRequestWithGraphPath:self.requestPath];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(facebookRequestDidComplete:)name:kRequestCompletedNotification
                                                       object:nil];
            break;
        case CH_SERVICE_TWITTER:
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            NSString *identifier = [tweeterEngine getImageAtURL:[dictionary objectForKey:@"profile_image_url"]];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(twitterProfileImageRequestDidComplete:)
                                                         name:identifier
                                                       object:nil];
        default:
            break;
    }
}


/////////////////////////////////twitter
- (void)twitterProfileImageRequestDidComplete:(NSNotification*)notification {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.photoImageView.image = [notification.userInfo objectForKey:@"profile_image"];
	[self setNeedsLayout];
}


/////////////////////////////////facebook
- (void)facebookRequestDidComplete:(NSNotification*)notification {
    
    if (YES == [self.requestPath isEqualToString:[notification.userInfo objectForKey:@"path"]]) {
        
        UIImage *image = [UIImage imageWithData:(NSData*)[notification.userInfo objectForKey:@"result"]];
        self.photoImageView.image = image;
        [self setNeedsLayout];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (IBAction)addFriendTapped:(id)sender
{
    
}

@end
