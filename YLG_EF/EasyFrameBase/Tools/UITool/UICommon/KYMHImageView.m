//
//  KYMHImageView.m
//  NewTest
//
//  Created by MH on 16/2/1.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import "KYMHImageView.h"

@implementation KYMHImageView

- (instancetype)initWithImage:(UIImage *)image BaseSize:(CGRect)_baseSize ImageViewColor:(UIColor*)_imageViewColor{
    self = [super initWithFrame:_baseSize];
    if (self) {
        self.image = image;
        if (!_imageViewColor) {
            _imageViewColor = [UIColor clearColor];
        }
        self.backgroundColor = _imageViewColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)RectSize:(CGFloat)_rectSize SideWidth:(CGFloat)_sideWidth SideColor:(UIColor*)_sideColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = _rectSize;
    self.layer.borderColor = _sideColor.CGColor;
    self.layer.borderWidth = _sideWidth;
}

@end
