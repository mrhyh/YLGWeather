//
//  BlockButton.h
//  KYiOS
//
//  Created by mini珍 on 15/9/23.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BlockButton;
typedef void (^TouchButton)(BlockButton*);

@interface BlockButton : UIButton

@property(nonatomic,copy)TouchButton block;

@end
