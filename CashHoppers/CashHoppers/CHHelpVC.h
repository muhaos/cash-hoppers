//
//  CHHelpVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHelpVC : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;
@property (retain, nonatomic) NSString* url;
@end
