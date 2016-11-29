//
//  KYShakerKY.h
//  hujinrong
//
//  Created by MH on 16/5/5.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYShaker : NSObject
- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithViewsArray:(NSArray *)viewsArray;

- (void)shake;
- (void)shakeWithDuration:(NSTimeInterval)duration completion:(void (^)())completion;
@end
