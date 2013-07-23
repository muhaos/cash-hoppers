//
//  UIButton+CustomFont.m
//  CashHoppers
//
//  Created by Vova Musiienko on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "UIButton+CustomFont.h"

@implementation UIButton (CustomFont)

- (NSString *)fontName {
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end
