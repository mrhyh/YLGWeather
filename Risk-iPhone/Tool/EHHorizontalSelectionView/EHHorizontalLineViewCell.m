//
//  HorizontalViewCell.m
//  TvRemote
//
//  Created by Danila Gusev on 29/02/2016.
//  Copyright © 2016 com.abrt. All rights reserved.
//

#import "EHHorizontalLineViewCell.h"
#import "EHHorizontalViewCell.h"

@implementation EHHorizontalLineViewCell

static float _EHHorizontalColorHeight = 4;
static float _EHHorizontalUnderlineLong = 60;  //默认初始宽度
static float _EHHorizontalUnderlineMultiple = 1.5;  //下划线长度是title文本长度的~分之一
static float _EHHorizontalTitleFont = 15; //title默认字体大小
static BOOL _isNotFirst;  //标志是否第一次，用于设置title的初始默认选中颜色

+ (float)cellGap
{
    return _EHDefaultGap * 8;
}

- (UIView *)createSelectedView
{
    self.clipsToBounds = NO;
    self.coloredView.layer.shadowRadius = 7.5;
    self.coloredView.layer.shadowOffset = CGSizeMake(0, 0);
    self.coloredView.layer.masksToBounds = NO;
    self.coloredView.layer.shadowColor = self.coloredView.backgroundColor.CGColor;
    self.coloredView.layer.shadowOpacity = 1;
    self.selectedView.clipsToBounds = NO;
    
    self.titleLabel.frame = self.bounds;
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView * tLabel = self.titleLabel;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tLabel)]];
    
    [self updateSelectedFrames];
    return self.selectedView;
}



+ (float)colorHeight
{
    return _EHHorizontalColorHeight;
}

+ (void)updateColorHeight:(float)newH
{
    _EHHorizontalColorHeight = newH;
}

//更新下划线的长度

- (void)updateSelectedFrames
{
    self.selectedView.frame = self.bounds;
    //self.coloredView.frame = CGRectMake(0, self.selectedView.bounds.size.height - [[self class] colorHeight], self.selectedView.bounds.size.width, [[self class] colorHeight]);
    _EHHorizontalUnderlineLong = self.bounds.size.width/_EHHorizontalUnderlineMultiple;
    NSLog(@"self.selectedView.frame: %@", NSStringFromCGRect( self.selectedView.frame));
     self.coloredView.frame = CGRectMake((self.selectedView.bounds.size.width - _EHHorizontalUnderlineLong)/2, self.selectedView.bounds.size.height - [[self class] colorHeight], _EHHorizontalUnderlineLong, [[self class] colorHeight]);
    
    //(self.selectedView.bounds.size.width - _EHHorizontalUnderlineLong)/2
}

- (void)updateFramesForMovingFromRect:(CGRect)rect
{
    self.selectedView.frame = CGRectMake(CGRectGetMinX(rect) - CGRectGetMinX(self.frame), 0, rect.size.width/_EHHorizontalUnderlineMultiple, self.selectedView.bounds.size.height);
    self.coloredView.frame = CGRectMake((self.selectedView.bounds.size.width - _EHHorizontalUnderlineLong)/2 , self.selectedView.bounds.size.height - [[self class] colorHeight], self.selectedView.bounds.size.width, [[self class] colorHeight]);
}

- (void)setSelectedCell:(BOOL)selected fromCellRect:(CGRect)rect
{
    if (selected) // 选中
    {
        self.selectedView.hidden = NO;
        [self updateSelectedFrames];
        if (!CGRectIsNull(rect))
        {
            [self updateFramesForMovingFromRect:rect];
            self.titleLabel.textColor = EF_MainColor;
            
            [UIView animateWithDuration:0.4 animations:^{
                [self updateSelectedFrames];
            }];
        }
        
        [UIView animateWithDuration:!CGRectIsNull(rect) ? 0.3 : 0.0 animations:^{
            self.titleLabel.font = self.fontMedium ? self.fontMedium : [[self class] fontMedium];
            self.titleLabel.alpha = 1.0;
        }];
        
    }
    else  //未选中的情况
    {
        self.selectedView.hidden = YES;
        [UIView animateWithDuration:!CGRectIsNull(rect) ? 0.3 : 0.0 animations:^{
            self.titleLabel.font = self.font ? self.font : [[self class] font];
            self.titleLabel.alpha = .5;
            self.titleLabel.textColor = RGBColor(106, 107, 107);
        } completion:^(BOOL finished) {
        }];
    }
    
    //统一设置字体大小和透明值
    self.titleLabel.font = [UIFont systemFontOfSize:_EHHorizontalTitleFont];
    self.titleLabel.alpha = 1;
    
    //设置默认选中的title的颜色
    if (NO == _isNotFirst) {
        self.titleLabel.textColor = EF_MainColor;
    }
    _isNotFirst = YES;
}


- (void)setSelectedCell:(BOOL)selected
{
    [self setSelectedCell:selected fromCellRect:CGRectNull];
}
@end
