//
//  MyAutoAlertView.m
//  BusInquiry2
//
//  Created by infinite_2 on 13-7-22.
//
//

#import "EFMyAutoAlertView.h"
#import <QuartzCore/QuartzCore.h>
static EFMyAutoAlertView *curView = nil;


#define  BGColor  [UIColor colorWithWhite:.2f alpha:1]
@implementation EFMyAutoAlertView

+ (EFMyAutoAlertView *)shareInstance{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (curView == nil){
        curView = [[EFMyAutoAlertView alloc] initWithFrame:keyWindow.frame];
	}
	return curView;
}


#pragma -mark----网络请求等待提示框
+ (void) showActivity{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [EFMyAutoAlertView showActivityView:keyWindow andBGColor:[UIColor grayColor]];
}

+ (void) showActivityView:(UIView *)_parentView andBGColor:(UIColor*)_color{
    CGSize size = _parentView.frame.size;
    EFMyAutoAlertView *view = [EFMyAutoAlertView shareInstance];
    [view setFrame:_parentView.frame];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(size.width/2-60*SCREEN_W_RATE, size.height/2-10*SCREEN_H_RATE,120*SCREEN_W_RATE,50*SCREEN_H_RATE)];
    bgView.backgroundColor = _color;
    bgView.alpha = 1.0f;
    bgView.layer.cornerRadius = 6.0;
    [view addSubview:bgView];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    spinner.frame = CGRectMake(15*SCREEN_W_RATE, 15*SCREEN_H_RATE, 20*SCREEN_W_RATE, 20*SCREEN_H_RATE);
    [bgView addSubview:spinner];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(55*SCREEN_W_RATE, 15*SCREEN_H_RATE,70*SCREEN_W_RATE, 20*SCREEN_H_RATE)];
    text.text = @"请稍等...";
    text.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    text.textColor = [UIColor whiteColor];
    text.backgroundColor = [UIColor clearColor];
    [bgView addSubview:text];
    
	if ([view superview] != _parentView)
		[_parentView addSubview:view];
    
	view.alpha = 0.1;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];
	view.alpha = 1;
	[UIView commitAnimations];
}




#pragma --mark---普通文字提示框 自动隐藏--
+(void)showAlert:(NSString *)_text{
    [EFMyAutoAlertView showAlert:_text andBGColor:BGColor];
}
	
+(void)showAlert:(NSString *)_text andBGColor:(UIColor *)_color{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [EFMyAutoAlertView showAlter:_text ParentView:keyWindow andBGColor:_color];
}

+ (void) showAlter:(NSString *)_text ParentView:(UIView *)_parentView andBGColor:(UIColor*)_color{
    CGSize size = _parentView.frame.size;
    CGSize contentSize = [_text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:16] constrainedToSize:CGSizeMake(250, 100) lineBreakMode:NSLineBreakByCharWrapping];

    EFMyAutoAlertView *view = [EFMyAutoAlertView shareInstance];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((size.width-contentSize.width)/2-10*SCREEN_W_RATE, (size.height-contentSize.height)/2-10*SCREEN_H_RATE, contentSize.width+20*SCREEN_W_RATE, contentSize.height+20*SCREEN_H_RATE)];
    bgView.backgroundColor = _color;
    bgView.alpha = 0.9;
    bgView.layer.cornerRadius = 6.0;
    [view addSubview:bgView];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10*SCREEN_W_RATE, 10*SCREEN_H_RATE, contentSize.width, contentSize.height+5*SCREEN_H_RATE)];
    text.text = _text;
    text.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    text.textColor = [UIColor whiteColor];
    text.numberOfLines = 0;
    text.backgroundColor = [UIColor clearColor];
    [bgView addSubview:text];;
    
	if ([view superview] != _parentView)
		[_parentView addSubview:view];
    
	view.alpha = 0.1;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.1];
	view.alpha = 1;
	[UIView commitAnimations];
    
    float delay = _text.length/8.f;
    [view performSelector:@selector(hide) withObject:nil afterDelay:delay];
}




+ (void)hide{
    EFMyAutoAlertView *ai = [EFMyAutoAlertView shareInstance];
    if (ai && [ai superview]) {
        [ai hide];
    }
}


- (void)hide{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	self.alpha = 0;
	[UIView commitAnimations];
    curView = nil;
}

+ (void)hideNoDelay{
    curView = nil;
}

@end
