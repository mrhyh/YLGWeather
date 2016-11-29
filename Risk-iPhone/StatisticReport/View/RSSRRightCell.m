//
//  RSSRRightCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSSRRightCell.h"

@interface RSSRRightCell ()

@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *phoneNumLabel;
@property (nonatomic, strong) KYMHLabel *mensesDataLabel;

@end

@implementation RSSRRightCell {
    CGFloat cellH;
    UIColor *textColor;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setup {
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

    NSArray *views = @[_topLineView, _medicalRecordNumLabel, _nameLabel,_phoneNumLabel,  _mensesDataLabel , _bottomLineView];
    [self.contentView sd_addSubviews:views];
    
    _topLineView.sd_layout
    .topSpaceToView(self.contentView, 1)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    _bottomLineView.sd_layout
    .bottomSpaceToView(self.contentView, 1)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    [_bottomLineView bringSubviewToFront:self.contentView];
    [_topLineView bringSubviewToFront:self.contentView];
}


- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH)];
    lineView.backgroundColor = EF_TextColor_TextColorDisable;
    [label addSubview:lineView];
    
    return label;
}

- (void) setModel:(reportModel *)model {
    _model = model;
    _medicalRecordNumLabel.text = model.catName;
    _nameLabel.text = model.name;
    _phoneNumLabel.text = model.fdaType;
    _mensesDataLabel.text = model.nums;
    
    //cell高度适配
    UIView *bottomView;
    bottomView = _bottomLineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

@end
