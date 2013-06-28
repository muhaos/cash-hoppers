//
//  CHLoadingVC.m
//
//  Created by Eugene Hyrol on 27.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "CHLoadingVC.h"

@interface CHLoadingVC ()

@property (strong, nonatomic) IBOutlet UILabel* textLabel;

@end

@implementation CHLoadingVC

+ (CHLoadingVC*) sharedLoadingVC {
    static CHLoadingVC* instance = nil;
    if (instance == nil) {
        instance = [[CHLoadingVC alloc] initWithNibName:@"CHLoadingVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c withText:(NSString*) text {
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"WDLoadingVC" reason:@"Loading controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    self.textLabel.text = text;
}


- (void) hide {
    [self.view removeFromSuperview];
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

@end
