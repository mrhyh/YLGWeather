//
//  RSTextField.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/10.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSTextField.h"

@implementation RSTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    
    UIColor *placeholderColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];//设置颜色
    [placeholderColor setFill];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
    [self.placeholder drawInRect:CGRectMake(0, 2.5, self.frame.size.width, self.frame.size.height) withAttributes:attr];
}

@end
