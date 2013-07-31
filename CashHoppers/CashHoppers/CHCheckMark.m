//
//  CHCheckMark.m
//  CashHoppers
//
//  Created by Eugene on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHCheckMark.h"
#import <QuartzCore/QuartzCore.h>

@implementation CHCheckMark

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)awakeFromNib{
    _checked = NO;
    [self setBackgroundColor:[UIColor whiteColor]];

    [self setTitle:@"" forState:UIControlStateNormal];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
}
-(void)toggleCheck{
    
    _checked = !_checked;

    if(_checked){
        [self setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    }else{
        [self setImage:nil forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    if (CGRectContainsPoint(self.bounds,[touch locationInView: self]))
    {
        [self toggleCheck];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
