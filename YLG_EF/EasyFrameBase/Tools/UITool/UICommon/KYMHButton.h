//
//  KYMHButton.h
//  NewTest
//
//  Created by MH on 16/2/1.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#if NS_BLOCKS_AVAILABLE
typedef void (^KYMHButtonTouchBlock)();
#endif


@interface KYMHButton : UIButton

/**
 *  基础按钮
 *
 *  @param view               添加方法的id
 *  @param _title             文字
 *  @param _baseSize          按钮基础Size
 *  @param _buttonColor       按钮的颜色
 *  @param _buttonFont        按钮的字号
 *  @param _buttonTitleColor  按钮的字体颜色
 *  @param action             方法
 */
- (instancetype)initWithbarButtonItem:(id)view Title:(NSString *)_title BaseSize:(CGRect)_baseSize ButtonColor:(UIColor*)_buttonColor ButtonFont:(CGFloat)_buttonFont ButtonTitleColor:(UIColor*)_buttonTitleColor Block:(KYMHButtonTouchBlock)action;

@property(nonatomic,copy)KYMHButtonTouchBlock block;

/**
 *  图片
 *
 *  @param _backgroundImage 图片
 */
- (void)ButtonImage:(UIImage *)_image;

/**
 *  背景图片
 *
 *  @param _backgroundImage 背景图片
 */
- (void)BackgroundImage:(UIImage *)_backgroundImage;

/**
 *  圆角
 *
 *  @param _rectSize  圆角的size
 *  @param _sideWidth 边宽
 *  @param _sideColor 边的颜色
 */
- (void)RectSize:(CGFloat)_rectSize SideWidth:(CGFloat)_sideWidth SideColor:(UIColor*)_sideColor;



//上下居中，图片在上，文字在下
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)verticalCenterImageAndTitle; //默认6.0

//左右居中，文字在左，图片在右
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImage; //默认6.0

//左右居中，图片在左，文字在右
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)horizontalCenterImageAndTitle; //默认6.0

//文字居中，图片在左边
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageLeft; //默认6.0

//文字居中，图片在右边
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageRight; //默认6.0


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
 *  涟漪的颜色
 */
@property (nonatomic, strong) UIColor *flashColor;

@property (nonatomic, assign) BOOL flashButtonType;
@end
