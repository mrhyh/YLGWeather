//
//  EFTagButton.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/26.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFTagButton.h"

@implementation EFTagButton
#pragma mark --- 重写父类的setter方法
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected == YES) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;
    }else{
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
    }
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled == YES) {
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor lightGrayColor];
    }
}
@end
