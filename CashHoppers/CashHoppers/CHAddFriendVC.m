//
//  CHAddFriendVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/22/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendVC.h"

@interface CHAddFriendVC ()

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation CHAddFriendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customBackButton];
    
    [self.photoImageView setImage:[UIImage imageNamed:@"photo_hop"]];
    [self.nameLabel setText:@"Brian Kelly"];
    [self.descTextView setText:@"Owner of Hayes and Taylor Apparel. UI/UX/Graohic Designer.Buckey Fan. Indianapolis, 1N"];
    [self.countFriendsLabel setText:@"78 Friends"];
}


-(void)customBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setNameLabel:nil];
    [self setDescTextView:nil];
    [self setCountFriendsLabel:nil];
    [self setYourFriendsImageView:nil];
    [self setAddFriendButton:nil];
    [super viewDidUnload];
}


- (IBAction)addFriendTapped:(id)sender
{
    self.addFriendButton.hidden = YES;
    [self.yourFriendsImageView setImage:[UIImage imageNamed:@"you_are_friends.png"]];
    
//url: http://localhost:3000/api/friends/send_request.json
//data: {"api_key":"123","authentication_token":"dciI7a6wizkbaYAicqAJUdJo15S3R3","friend_id":"2337"}
//response:
//success: {"success"=>true, "info"=>"Friend request sent.", "status"=>200}
//error: {"errors"=>["Can't find user by id 2337"], "success"=>false, "status"=>406}
   
    id authentication_token, api_key, friend_id;
    
    // создаем запрос
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/api/friends/send_request.json"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];

    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 api_key, @"123",
                                 authentication_token, @"dciI7a6wizkbaYAicqAJUdJo15S3R3",
                                 friend_id, @"2337",
                                 nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        // соединение началось
        NSLog(@"Connecting...");
        // создаем NSMutableData, чтобы сохранить полученные данные
        _responseData= [NSMutableData data];
    } else {
        // при попытке соединиться произошла ошибка
        NSLog(@"Connection error!");
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // добавляем новые данные к receivedData
    [self.responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // данные получены
    // здесь можно произвести операции с данными
    NSLog(@"response data - %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    NSString *errorString = [[NSString alloc] initWithFormat:
                             @"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(@"%@", errorString);
}


@end
