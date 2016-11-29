//
//  EFPopupViewManager.h
//  Symiles
//
//  Created by Jack on 3/9/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class EFPopupView;

@interface EFPopupViewManager : NSObject

- (void)showPopupView : (EFPopupView *)_view Animate : (BOOL)_animate;

- (void)hidePopupViewWithAnimate : (BOOL)_animate;

+ (void)showPopupView : (EFPopupView *)_view Animate : (BOOL)_animate;

+ (void)hidePopupViewWithAnimate : (BOOL)_animate;

+ (EFPopupViewManager *)shareInstance;

@end


@interface EFPopupView : UIView

- (void)showPopupViewWithAnimate:(BOOL)_animate;
- (void)hidePopupWithAnimate:(BOOL)_animate;
- (void)popupDidClosed;
@end