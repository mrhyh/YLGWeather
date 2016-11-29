//
//  HYDActivityMessageView.h
//  Exam
//
//  Created by  on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDActivityIndicatorView.h"

@interface HYDActivityMessageView : HYDActivityIndicatorView{
    UILabel                 * messageLabel;
}

- (void) setMessage : (NSString *)_msg;

+ (HYDActivityMessageView *)currentIndicator;



+ (void) showMessage : (NSString *)_msg;
+ (void) showMessage : (NSString *)_msg WithFrame : (CGRect)_frame;
+ (void) showMessage : (NSString *)_msg ParentView : (UIView *)_parentView Frame : (CGRect)_frame;
+ (void) showMessage : (NSString *)_msg AfterHideDelay : (NSTimeInterval)_delay;
@end
