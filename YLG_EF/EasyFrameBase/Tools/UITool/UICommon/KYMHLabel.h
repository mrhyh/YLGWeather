//
//  KYMHLabel.h
//  NewTest
//
//  Created by MH on 16/1/29.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYMHLabel : UILabel

/**
 *  基础标签
 *
 *  @param _title            文字
 *  @param _baseSize         基础Size
 *  @param _labelColor       标签的颜色
 *  @param _labelFont        标签的字号
 *  @param _labelTitleColor  标签的字体颜色
 *  @param _textAlignment    对齐方式
 */
- (instancetype)initWithTitle:(NSString *)title BaseSize:(CGRect)_baseSize LabelColor:(UIColor*)_labelColor LabelFont:(CGFloat)_labelFont LabelTitleColor:(UIColor*)_labelTitleColor TextAlignment:(NSTextAlignment)_textAlignment;


/**
 *  使用字重(iOS8.2以上可用)
 *
 *  @param _fontWeight 字重
 */
- (void)FontWeight:(CGFloat)_fontWeight;

/**
 *  使用IconFont方法
 *
 *  @param _iconFont IconFont的名字
 */
- (void)IconFont:(NSString*)_iconFont;

/**
 *  圆角
 *
 *  @param _rectSize 圆角的size
 *  @param _sideWidth 边宽
 *  @param _sideColor 边的颜色
 */
- (void)RectSize:(CGFloat)_rectSize SideWidth:(CGFloat)_sideWidth SideColor:(UIColor*)_sideColor;



@end



