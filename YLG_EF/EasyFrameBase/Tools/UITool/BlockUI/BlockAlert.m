//
//  BlockAlert.m
//  KYiOS
//
//  Created by mini珍 on 15/9/23.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import "BlockAlert.h"

@implementation BlockAlert

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles block:(TouchBlock)block{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _block(buttonIndex);
}


@end
