//
//  YLTextField.m
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFCTTextField.h"



@interface EFCTTextField ()

@end

@implementation EFCTTextField


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;

}

//设置默认值
- (void ) initData {
    _cursorToLeft = 5;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_cursorToLeft, bounds.origin.y, bounds.size.width -_cursorToLeft, bounds.size.height);//更好理解些
    return inset;
    
}

//控制编辑文本的位置（ 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变）
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +_cursorToLeft, bounds.origin.y, bounds.size.width -_cursorToLeft, bounds.size.height);
    return inset;
}


@end
