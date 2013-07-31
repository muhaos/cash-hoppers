//
//  CHCheckMark.h
//  CashHoppers
//
//  Created by Eugene on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCheckMark : UIButton

@property (nonatomic, assign)BOOL checked;

-(void)toggleCheck;

@end
