//
//  RSRKQuickViewMenuVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/13.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RSRKQuickViewMenuVC;

@protocol RSRKQuickViewMenuVCDelegate <NSObject>

@optional

- (void)menuSelected:(NSString *)string;

@end

@interface RSRKQuickViewMenuVC : UIViewController

@property (weak, nonatomic) id<RSRKQuickViewMenuVCDelegate> delegate;

- (instancetype)initWithArray:(NSArray *)array;


@end
