//
//  HYDActivityIndicatorView.m
//  Exam
//
//  Created by  on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>


@implementation HYDActivityIndicatorView

@synthesize indicator;

static HYDActivityIndicatorView *currentIndicator = nil;


- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, spinner.frame.size.width + 20, spinner.frame.size.height + 20)];
        [self addSubview:indicator];
        [indicator addSubview:spinner];
        [spinner startAnimating];
        spinner.center = CGPointMake(indicator.frame.size.width / 2 , indicator.frame.size.height / 2);
        indicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        indicator.opaque = NO;
        indicator.layer.cornerRadius = 5;
        indicator.userInteractionEnabled = NO;
        indicator.autoresizesSubviews = YES;
        indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setProperRotation)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self hidden];
    }];
}

- (void)hidden{
    [self removeFromSuperview];
    if (currentIndicator) {
        currentIndicator = nil;
    }
}

- (void)dealloc
{
    [self.layer removeAllAnimations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (HYDActivityIndicatorView *)currentIndicator{
    if (currentIndicator == nil)
	{
        currentIndicator = [[HYDActivityIndicatorView alloc] init];
	}
	return currentIndicator;
}


+ (void) show{
    HYDActivityIndicatorView *ai = [HYDActivityIndicatorView currentIndicator];
    CGRect frame = [[UIApplication sharedApplication] keyWindow].frame;
    [HYDActivityIndicatorView showIndicator:ai WithFrame:frame];
}

+ (void) showWithParentView : (UIView *)_parentView{
    [HYDActivityIndicatorView showWithParentView:_parentView Frame:_parentView.frame];
}

+ (void) showWithParentView : (UIView *)_parentView Frame : (CGRect)_frame{
    HYDActivityIndicatorView *ai = [HYDActivityIndicatorView currentIndicator];
    [HYDActivityIndicatorView showIndicator:ai ParentView:_parentView WithFrame:_frame]; 
}

+ (void) showIndicator : (HYDActivityIndicatorView *)ai WithFrame : (CGRect)_frame{
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [HYDActivityIndicatorView showIndicator:ai ParentView:keyWindow WithFrame:_frame];
}

+ (void) showIndicator : (HYDActivityIndicatorView *)_ai ParentView : (UIView *)_parentView WithFrame : (CGRect)_frame{
    _ai.frame = _frame;
    _ai.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
	if ([_ai superview] != _parentView) 
		[_parentView addSubview:_ai];
    
	_ai.alpha = 0.1;
    [UIView animateWithDuration:0.3 animations:^{
        _ai.alpha = 1;
    }];
    [_ai setProperRotation:NO];
}

+ (void) showAfterHideDelay : (NSTimeInterval)_delay{
    [HYDActivityIndicatorView show];
    [HYDActivityIndicatorView hideAfterDelay:_delay];
}

+ (void) hide{
    HYDActivityIndicatorView *ai = [HYDActivityIndicatorView currentIndicator];
    if (ai && [ai superview]) {
        [ai hide];
    }
}

+ (void) hideAfterDelay : (NSTimeInterval)_delay{
    HYDActivityIndicatorView *ai = [HYDActivityIndicatorView currentIndicator];
    if (ai) {
        [ai performSelector:@selector(hide) withObject:nil afterDelay:_delay];
    }
}

- (void)setFrame:(CGRect)frame{
    super.frame = frame;
    if (frame.size.width==0&&frame.size.height==0) {
        return;
    }
    if (indicator.frame.size.width >= frame.size.width || indicator.frame.size.height >= frame.size.height ) {
        float scal = frame.size.width > frame.size.height ? frame.size.height : frame.size.width;
        [UIView animateWithDuration:0.3 animations:^{
            [indicator removeFromSuperview];
        }];
        UIActivityIndicatorView *_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.frame = CGRectMake(0, 0, scal/2, scal/2);
        _spinner.center = CGPointMake(frame.size.width / 2 , frame.size.height / 2);
        [self addSubview:_spinner];
    }
}

#pragma mark Rotation

- (void)setProperRotation
{
	[self setProperRotation:YES];
}

- (void)setProperRotation:(BOOL)animated
{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(0));
    return;
    
    //修改之前的
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
    float radians = 0;
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        if (orientation == UIDeviceOrientationPortrait){
            radians = 0;
        }
        else if (orientation == UIDeviceOrientationPortraitUpsideDown){
            radians = 180;
        }
        else if (orientation == UIDeviceOrientationLandscapeLeft){
            radians = 90;
        }
        else if (orientation == UIDeviceOrientationLandscapeRight){
            radians = -90;
        }
        else {
            if (animated){
                [UIView commitAnimations];
            }
            return;
        }
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(radians));
    }
	if (animated)
		[UIView commitAnimations];
}

@end
