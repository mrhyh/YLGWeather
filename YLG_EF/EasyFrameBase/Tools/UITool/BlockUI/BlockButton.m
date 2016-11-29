//
//  BlockButton.m
//  KYiOS
//
//  Created by mini珍 on 15/9/23.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchAction:(id)sender{
    _block(self);
}


@end
