//
//  KYMHLabel.m
//  NewTest
//
//  Created by MH on 16/1/29.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import "KYMHLabel.h"
//系统版本号
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
@implementation KYMHLabel{
    CGFloat labelFont;
}

- (instancetype)initWithTitle:(NSString *)title BaseSize:(CGRect)_baseSize LabelColor:(UIColor*)_labelColor LabelFont:(CGFloat)_labelFont LabelTitleColor:(UIColor*)_labelTitleColor TextAlignment:(NSTextAlignment)_textAlignment{
    self = [super initWithFrame:_baseSize];
    if (self) {
        if (!_labelColor) {
            _labelColor = [UIColor clearColor];
        }
        self.backgroundColor = _labelColor;
        self.text = title;
        self.textColor = _labelTitleColor;
        self.numberOfLines = 0;
        self.textAlignment = _textAlignment;
        self.font = [UIFont systemFontOfSize:(_labelFont)];
        labelFont = _labelFont;
    }
    return self;
}


- (void)FontWeight:(CGFloat)_fontWeight{
    self.font = [UIFont systemFontOfSize:labelFont weight:_fontWeight];
    if (CurrentSystemVersion < 8.2&&_fontWeight==UIFontWeightBold) {
        self.font = [UIFont boldSystemFontOfSize:(labelFont)];
    }
}

- (void)IconFont:(NSString*)_iconFont{
    self.font = [UIFont fontWithName:_iconFont size:labelFont];
}

- (void)RectSize:(CGFloat)_rectSize SideWidth:(CGFloat)_sideWidth SideColor:(UIColor*)_sideColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = _rectSize;
    self.layer.borderColor = _sideColor.CGColor;
    self.layer.borderWidth = _sideWidth;
}



@end
