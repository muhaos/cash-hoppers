//
//  UITextField+CustomFont.m
//  CashHoppers
//
//  Created by Vova Musiienko on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "UITextField+CustomFont.h"

@implementation UITextField (CustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
