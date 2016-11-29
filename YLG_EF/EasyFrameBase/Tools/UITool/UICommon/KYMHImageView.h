//
//  KYMHImageView.h
//  NewTest
//
//  Created by MH on 16/2/1.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYMHImageView : UIImageView

/**
 *  基础图片
 *
 *  @param image           图片
 *  @param _title          文字
 *  @param _baseSize       基础Size
 *  @param _imageViewColor 图片背景颜色
 */
- (instancetype)initWithImage:(UIImage *)image BaseSize:(CGRect)_baseSize ImageViewColor:(UIColor*)_imageViewColor;

/**
 *  圆角
 *
 *  @param _rectSize  圆角的size
 *  @param _sideWidth 边宽
 *  @param _sideColor 边的颜色
 */
- (void)RectSize:(CGFloat)_rectSize SideWidth:(CGFloat)_sideWidth SideColor:(UIColor*)_sideColor;
@end
