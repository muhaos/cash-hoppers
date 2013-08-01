//
//  CHAddFriendsCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendsCell.h"
#import "CHStartVC.h"
#import "CHAddFriendsSocialNetworksVC.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation CHAddFriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)twitterProfileImageRequestDidComplete:(NSNotification*)notification {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.photoImageView.image = [notification.userInfo objectForKey:@"profile_image"];
	[self setNeedsLayout];
}

- (void)setData:(NSDictionary *)dictionary {
	[data release];
	data = [dictionary retain];
    
	self.nameLabel.text = [data objectForKey:@"screen_name"];
    
    self.photoImageView.image = nil;
	[self setNeedsLayout];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSString *identifier = [tweeterEngine getImageAtURL:[dictionary objectForKey:@"profile_image_url"]];
	
	//listen for a notification with the name of the identifier
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(twitterProfileImageRequestDidComplete:)
												 name:identifier
											   object:nil];
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
