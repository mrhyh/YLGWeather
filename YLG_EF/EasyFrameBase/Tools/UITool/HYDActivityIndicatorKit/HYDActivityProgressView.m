//
//  HYDActivityProgressView.m
//  WildWestPoker_iPhone
//
//  Created by  on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDActivityProgressView.h"

@implementation HYDActivityProgressView

static HYDActivityProgressView *currentIndicator = nil;

- (id)init
{
    self = [super init];
    if (self) {
        indicator.frame = CGRectMake(0, 0, 120, 100);
        spinner.hidden = YES;
        [spinner stopAnimating];
        progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		progress.frame = CGRectMake(0,0,indicator.frame.size.width - 20,
                                    progress.frame.size.height);
        progress.center = CGPointMake(indicator.frame.size.width/2, 70);
        [indicator addSubview:progress];
        messageLabel.center = CGPointMake(indicator.frame.size.width/2, 40);
        messageLabel.font = [UIFont boldSystemFontOfSize:20];
        messageLabel.text = @"0.0%";
    }
    return self;
}

- (void)updateProgress : (CGFloat)_progress{
    progress.progress = _progress;
    messageLabel.text = [NSString stringWithFormat:@"%.2f%%",_progress * 100];
}

- (void)dealloc
{

}

+ (HYDActivityProgressView *)currentIndicator{
    if (currentIndicator == nil)
	{
        currentIndicator = [[HYDActivityProgressView alloc] init];
	}
	return currentIndicator;
}


#pragma mark -- show Message Methods


+ (void)showActivityProgress : (CGFloat)_progress{
    HYDActivityProgressView *ai = [HYDActivityProgressView currentIndicator];
    if ([ai superview] == nil) {
        [HYDActivityProgressView show];
    }
    [ai updateProgress:_progress];
}

+ (void) showMessage : (NSString *)_msg{
    [HYDActivityProgressView showMessage:_msg WithFrame:[[UIApplication sharedApplication] keyWindow].frame];
}

+ (void) showMessage : (NSString *)_msg WithFrame : (CGRect)_frame{
    HYDActivityMessageView *ai = [HYDActivityProgressView currentIndicator];
    [ai setMessage:_msg];
    [HYDActivityProgressView showIndicator:ai WithFrame:_frame];
}

+ (void) showMessage : (NSString *)_msg ParentView : (UIView *)_parentView Frame : (CGRect)_frame{
    HYDActivityMessageView *ai = [HYDActivityProgressView currentIndicator];
    [ai setMessage:_msg];
    [HYDActivityProgressView showIndicator:ai ParentView:_parentView WithFrame:_frame];
}

+ (void) showMessage : (NSString *)_msg AfterHideDelay : (NSTimeInterval)_delay{
    [HYDActivityProgressView showMessage:_msg WithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    [HYDActivityProgressView hideAfterDelay:_delay];
}





#pragma mark -- show Methods
//在全局Window中显示，并显示在最中央
+ (void) show{
    HYDActivityIndicatorView *ai = [HYDActivityProgressView currentIndicator];
    [HYDActivityProgressView showIndicator:ai WithFrame:[[UIApplication sharedApplication] keyWindow].frame]; 
}

//在ParentView中显示，并显示在ParentView的最中央
+ (void) showWithParentView : (UIView *)_parentView{
    [HYDActivityProgressView showWithParentView:_parentView Frame:_parentView.frame];
}

//在ParentView中显示，并根据传入的frame来决定显示位置
+ (void) showWithParentView : (UIView *)_parentView Frame : (CGRect)_frame{
    HYDActivityIndicatorView *ai = [HYDActivityProgressView currentIndicator];
    [HYDActivityProgressView showIndicator:ai ParentView:_parentView WithFrame:_frame]; 
}

//在全局Window中显示，并显示在最中央，并根据传入的delay进行隐藏并消失
+ (void) showAfterHideDelay : (NSTimeInterval)_delay{
    [HYDActivityProgressView show];
    [HYDActivityProgressView hideAfterDelay:_delay];
}



#pragma mark -- hide Methods
+ (void) hide{
    HYDActivityIndicatorView *ai = [HYDActivityProgressView currentIndicator];
    if (ai && [ai superview]) {
        [ai hide];
    }
}

+ (void) hideAfterDelay : (NSTimeInterval)_delay{
    HYDActivityIndicatorView *ai = [HYDActivityProgressView currentIndicator];
    if (ai) {
        [ai performSelector:@selector(hide) withObject:nil afterDelay:_delay];
    }
}


@end
