//
//  MyAutoAlertView.h
//  BusInquiry2
//
//  Created by infinite_2 on 13-7-22.
//
//

#import <UIKit/UIKit.h>

@protocol MyAlertViewDelegate; 


@interface EFMyAutoAlertView : UIView{
    UIView *indicator;
}


//在全局Window中显示，并显示在最中央 1s后自动消失 默认背景颜色
+(void) showAlert:(NSString *)_text;
+(void) showAlert:(NSString *)_text andBGColor:(UIColor *)_color;
+(void) showAlter:(NSString *)_text ParentView:(UIView *)_parentView andBGColor:(UIColor*)_color;

+ (void)hide;
+ (void)hideNoDelay;

+ (void) showActivity;
+ (void) showActivityView:(UIView *)_parentView andBGColor:(UIColor*)_color;



@end