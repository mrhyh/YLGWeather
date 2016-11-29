//
//  RSSRRightHeadView.m
//  Risk
//
//  Created by ylgwhyh on 16/8/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSSRRightHeadView.h"
#import "RSSReportModel.h"

@interface RSSRRightHeadView ( )

@end

@implementation RSSRRightHeadView {
    CGFloat cellH;
    UIColor *textColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self initData];
    }
    return self;
}

- (void ) setUp {
    
    cellH = 44;
    textColor = EF_TextColor_TextColorPrimary;
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = EF_TextColor_TextColorDisable;
    _topLineView.hidden = YES; //默认隐藏
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    CGFloat numberLabelW = 0;
    CGFloat oneLabelW = 120;
    CGFloat commonLabelW = (SCREEN_WIDTH - numberLabelW-oneLabelW)/3;
    
    _medicalRecordNumLabel = [self createLabelWithX:0 width:commonLabelW];
    _nameLabel = [self createLabelWithX:(numberLabelW + commonLabelW) width:oneLabelW];
    _phoneNumLabel = [self createLabelWithX:(numberLabelW + commonLabelW+oneLabelW) width:commonLabelW];
    _mensesDataLabel = [self createLabelWithX:(numberLabelW + 2*commonLabelW+oneLabelW) width:commonLabelW];
    
    self.backgroundColor = RGBColor(248, 249, 248);
    self.topLineView.hidden = NO;
    
    NSArray *views = @[_topLineView, _medicalRecordNumLabel, _nameLabel,_phoneNumLabel,  _mensesDataLabel , _bottomLineView];
    [self sd_addSubviews:views];
    
    _topLineView.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    _bottomLineView.sd_layout
    .bottomSpaceToView(self, 1)
    .leftSpaceToView(self, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    [_bottomLineView bringSubviewToFront:self];
    [_topLineView bringSubviewToFront:self];
}

- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH)];
    lineView.backgroundColor = EF_TextColor_TextColorDisable;
    [label addSubview:lineView];
    
    return label;
}

- (void ) initData {
    _medicalRecordNumLabel.text = @"风险类型";
    _nameLabel.text = @"风险因素";
    _phoneNumLabel.text = @"FDA";
    _mensesDataLabel.text = @"检索次数";
}

@end
