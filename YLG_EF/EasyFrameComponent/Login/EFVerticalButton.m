//
//  EFVerticalButton.m
//  demo
//
//  Created by HqLee on 16/5/20.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFVerticalButton.h"

@implementation EFVerticalButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [self setup];
}

- (void)setup{
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //调整图片的frame
    self.imageView.left = 0;
    self.imageView.top = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    //调整文字的frame
    self.titleLabel.left = 0;
    self.titleLabel.top = self.height - self.titleLabel.font.lineHeight;
    self.titleLabel.width = self.width;
    
}
@end
