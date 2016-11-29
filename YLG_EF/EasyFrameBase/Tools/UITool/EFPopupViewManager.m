//
//  EFPopupViewManager.m
//  Symiles
//
//  Created by Jack on 3/9/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFPopupViewManager.h"

@interface EFPopupViewManager (){
    UIView *overlayView;
    EFPopupView *popupView;
}

@end

@implementation EFPopupViewManager

static EFPopupViewManager * singleton;
+ (EFPopupViewManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[EFPopupViewManager alloc] init];
    });
    return singleton;
}

+ (void)showPopupView : (EFPopupView *)_view Animate : (BOOL)_animate{
    [[EFPopupViewManager shareInstance] showPopupView:_view Animate:_animate];
}

+ (void)hidePopupViewWithAnimate : (BOOL)_animate{
    [[EFPopupViewManager shareInstance] hidePopupViewWithAnimate:_animate];
}

- (void)showPopupView : (EFPopupView *)_view Animate : (BOOL)_animate{
    if (overlayView) {
        [self hidePopupViewWithAnimate:NO];
    }
    popupView = _view;
    overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    overlayView.backgroundColor = EF_TextColor_BlackHint;
    overlayView.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:overlayView];
    [overlayView addSubview:popupView];
    popupView.center = overlayView.center;
    
    if (_animate) {
        [UIView animateWithDuration:0.35 animations:^{
            overlayView.alpha = 1.0;
        }];
        
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [popupView.layer addAnimation:popAnimation forKey:nil];
    }
    else{
        overlayView.alpha = 1.0;
    }
}

- (void)hidePopupViewWithAnimate : (BOOL)_animate{
    if (_animate) {
        [UIView animateWithDuration:0.35 animations:^{
            overlayView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        
        CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        hideAnimation.duration = 0.4;
        hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
        hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
        hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        hideAnimation.delegate = self;
        [popupView.layer addAnimation:hideAnimation forKey:nil];
    }
    else{
        overlayView.hidden = YES;
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        popupView = nil;
        overlayView = nil;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [popupView popupDidClosed];
    [popupView removeFromSuperview];
    [overlayView removeFromSuperview];
    popupView = nil;
    overlayView = nil;
}

@end

@implementation EFPopupView

- (void)showPopupViewWithAnimate:(BOOL)_animate{
    [EFPopupViewManager showPopupView:self Animate:_animate];
}

- (void)hidePopupWithAnimate:(BOOL)_animate{
    [EFPopupViewManager hidePopupViewWithAnimate:_animate];
}

- (void)popupDidClosed{
    
}

@end