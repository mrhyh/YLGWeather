//
//  BlockAlert.h
//  KYiOS
//
//  Created by mini珍 on 15/9/23.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertBlock;
typedef void (^TouchBlock)(NSInteger);
@interface BlockAlert : UIAlertView

@property(nonatomic,copy)TouchBlock block;
//需要自定义初始化方法，调用Block
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles
              block:(TouchBlock)block;
@end
