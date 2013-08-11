//
//  CHMenuSlidingVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/10/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMenuSlidingVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *menuTable;

- (IBAction)logoutButtonTapped:(id)sender;

@end
