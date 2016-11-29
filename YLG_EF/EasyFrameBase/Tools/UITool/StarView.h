//
//  StarView.h
//  star
//
//  Created by KingYon on 15/4/17.
//  Copyright (c) 2015年 KingYon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

@property (nonatomic,assign) float starLevel;
@property (nonatomic,assign) float starScale;
@property (nonatomic,assign) BOOL isTouchaAailable;



@property (nonatomic,assign) CGFloat starViewH;
@property (nonatomic,assign) CGFloat starViewW;
/***  星星之间的间距*/
@property (nonatomic,assign) CGFloat starSpace;
/***  星星的宽高*/
@property (nonatomic,assign) CGFloat starW;

- (instancetype)initViewWithFrame:(CGRect)frame starSpace:(CGFloat)starSpace
                            starW:(CGFloat) starW;

@end
