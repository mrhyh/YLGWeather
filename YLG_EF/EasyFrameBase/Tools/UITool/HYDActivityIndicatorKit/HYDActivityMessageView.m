//
//  HYDActivityMessageView.m
//  Exam
//
//  Created by  on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDActivityMessageView.h"

@implementation HYDActivityMessageView

static HYDActivityMessageView *currentIndicator = nil;

- (id)init
{
    self = [super init];
    if (self) {
        indicator.frame = CGRectMake(0, 0, 120, 100);
        spinner.center = CGPointMake(60, 30);
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 120, 25)];
        messageLabel.text = @"请稍后...";
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        [indicator addSubview:messageLabel];
        
    }
    return self;
}

- (void)dealloc
{
    }

- (void)hidden{
    if (self.alpha > 0)
		return;
    [self removeFromSuperview];
    if (currentIndicator) {
        currentIndicator = nil;
    }
}

- (void) setMessage : (NSString *)_msg{
    messageLabel.text = _msg;
}


+ (HYDActivityMessageView *)currentIndicator{
    if (currentIndicator == nil)
	{
        currentIndicator = [[HYDActivityMessageView alloc] init];
	}
	return currentIndicator;
}

#pragma mark -- show Message Methods

+ (void) showMessage : (NSString *)_msg{
    CGRect frame = [[UIApplication sharedApplication] keyWindow].frame;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        if (frame.size.width < frame.size.height) {
            frame = CGRectMake(0,0, frame.size.height, frame.size.width);
        }
    }
    [HYDActivityMessageView showMessage:_msg WithFrame:frame];
}

+ (void) showMessage : (NSString *)_msg WithFrame : (CGRect)_frame{
    HYDActivityMessageView *ai = [HYDActivityMessageView currentIndicator];
    [ai setMessage:_msg];
    [HYDActivityMessageView showIndicator:ai WithFrame:_frame];
}

+ (void) showMessage : (NSString *)_msg ParentView : (UIView *)_parentView Frame : (CGRect)_frame{
    HYDActivityMessageView *ai = [HYDActivityMessageView currentIndicator];
    [ai setMessage:_msg];
    [HYDActivityMessageView showIndicator:ai ParentView:_parentView WithFrame:_frame];
}

+ (void) showMessage : (NSString *)_msg AfterHideDelay : (NSTimeInterval)_delay{
    [HYDActivityMessageView showMessage:_msg WithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    [HYDActivityMessageView hideAfterDelay:_delay];
}





#pragma mark -- show Methods
//在全局Window中显示，并显示在最中央
+ (void) show{
    HYDActivityMessageView *ai = [HYDActivityMessageView currentIndicator];
    [HYDActivityMessageView showIndicator:ai WithFrame:[[UIApplication sharedApplication] keyWindow].frame];
}

//在ParentView中显示，并显示在ParentView的最中央
+ (void) showWithParentView : (UIView *)_parentView{
    [HYDActivityMessageView showWithParentView:_parentView Frame:_parentView.frame];
}

//在ParentView中显示，并根据传入的frame来决定显示位置
+ (void) showWithParentView : (UIView *)_parentView Frame : (CGRect)_frame{
    HYDActivityIndicatorView *ai = [HYDActivityMessageView currentIndicator];
    [HYDActivityMessageView showIndicator:ai ParentView:_parentView WithFrame:_frame]; 
}

//在全局Window中显示，并显示在最中央，并根据传入的delay进行隐藏并消失
+ (void) showAfterHideDelay : (NSTimeInterval)_delay{
    [HYDActivityMessageView show];
    [HYDActivityMessageView hideAfterDelay:_delay];
}



#pragma mark -- hide Methods
+ (void) hide{
    HYDActivityIndicatorView *ai = [HYDActivityMessageView currentIndicator];
    if (ai && [ai superview]) {
        [ai hide];
    }
}



+ (void) hideAfterDelay : (NSTimeInterval)_delay{
    HYDActivityIndicatorView *ai = [HYDActivityMessageView currentIndicator];
    if (ai) {
        [ai performSelector:@selector(hide) withObject:nil afterDelay:_delay];
    }
}


@end
