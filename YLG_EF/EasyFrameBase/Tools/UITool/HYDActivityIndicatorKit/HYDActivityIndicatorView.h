//
//  HYDActivityIndicatorView.h
//  Exam
//
//  Created by  on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHKdegreesToRadians(x) (M_PI * x / 180.0)



@interface HYDActivityIndicatorView : UIView{
    UIView                      * indicator;
    UIActivityIndicatorView     * spinner;
}

@property (nonatomic,readonly)UIView    *indicator;

//渐变隐藏，并消失掉
- (void)hide;
//直接隐藏，并消失
- (void)hidden;
- (void)setProperRotation:(BOOL)animated;


+ (HYDActivityIndicatorView *)currentIndicator;

//类方法，显示全局动态指示
#pragma mark -- show Methods
//在全局Window中显示，并显示在最中央
+ (void) show;

//在ParentView中显示，并显示在ParentView的最中央
+ (void) showWithParentView : (UIView *)_parentView;

//在ParentView中显示，并根据传入的frame来决定显示位置
+ (void) showWithParentView : (UIView *)_parentView Frame : (CGRect)_frame;

//在全局Window中显示，并显示在最中央，并根据传入的delay进行隐藏并消失
+ (void) showAfterHideDelay : (NSTimeInterval)_delay;

+ (void) showIndicator : (HYDActivityIndicatorView *)_ai WithFrame : (CGRect)_frame;
+ (void) showIndicator : (HYDActivityIndicatorView *)_ai ParentView : (UIView *)_parentView WithFrame : (CGRect)_frame;


#pragma mark -- hide Methods
+ (void) hide;
+ (void) hideAfterDelay : (NSTimeInterval)_delay;

@end

@interface UIActivityIndicatorView (HYDActivity)
    
@end
