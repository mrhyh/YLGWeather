//
//  EFMallCell.m
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallCell.h"

const CGFloat titleLabelFontSize = 15;
CGFloat maxTitleLabelHeight = 0;
const CGFloat contentLabelFontSize = 13;
CGFloat maxContentLabelHeight = 0;

@implementation EFMallCell{
    UILabel * _titleLabel;
    UILabel * _contentLabel;
    UILabel * _priceLabel;
    UILabel * _pricedLabel;
    UIView   *_line;
    KYMHImageView *_iconView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    _iconView = [KYMHImageView new];
    UIColor * sideColor = HEX_COLOR(@"#a2a2a2");
    [_iconView RectSize:5 SideWidth:0.5 SideColor:sideColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:titleLabelFontSize];
    _titleLabel.textColor = EF_TextColor_TextColorPrimary;
//    _titleLabel.text = @"Oral-B 欧乐 D20.525.4X 4000 3D自能电动牙刷";
    if (maxTitleLabelHeight == 0) {
        maxTitleLabelHeight = _titleLabel.font.lineHeight * 3;
    }
    
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.textColor = EF_TextColor_TextColorSecondary;
//    _contentLabel.text = @"武侯区金翼牙科医院";
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:15];
//    _priceLabel.text = @"¥599";
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.textColor = [UIColor grayColor];
    
//    UIColor * cutColor =  EF_TextColor_TextColorDisable;
    _pricedLabel = [UILabel new];
    _pricedLabel.textAlignment = NSTextAlignmentLeft;
//    NSAttributedString *attrStr =
//    [[NSAttributedString alloc]initWithString:@"原价1299"
//                                  attributes:
//  @{NSFontAttributeName:[UIFont systemFontOfSize:13],
//    NSForegroundColorAttributeName:cutColor,
//    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
//    NSStrikethroughColorAttributeName:cutColor}];
//    
//    _pricedLabel.attributedText = attrStr;
    
    _line = [UIView new];
    _line.backgroundColor = EF_TextColor_TextColorDisable;
    
    
    NSArray *views = @[_iconView, _titleLabel, _contentLabel, _priceLabel, _pricedLabel, _line];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;

    _iconView.sd_layout
    .leftSpaceToView(contentView, 5)
    .topSpaceToView(contentView, margin)
    .widthIs(100)
    .heightIs(100);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_titleLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _priceLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_contentLabel, margin)
    .heightIs(20);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:80*SCREEN_W_RATE];
    
    
    _pricedLabel.sd_layout
    .leftSpaceToView(_priceLabel, margin)
    .topSpaceToView(_contentLabel, margin)
    .heightIs(20);
    [_pricedLabel setSingleLineAutoResizeWithMaxWidth:120*SCREEN_W_RATE];
    
    _line.sd_layout
    .leftEqualToView(contentView)
    .topSpaceToView(_iconView, 10)
    .heightIs(0.5)
    .widthIs(SCREEN_WIDTH);
    
}

#pragma mark --- setter
- (void)setListModel:(EFMallGoodListModel *)listModel{
    _listModel = listModel;
    _titleLabel.text = listModel.name;
    _contentLabel.text = listModel.shopItem.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%zd",listModel.price];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:listModel.image.url] placeholderImage:nil];
    UIColor * cutColor =  EF_TextColor_TextColorDisable;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价%zd",listModel.marketPrice]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:13],
       NSForegroundColorAttributeName:cutColor,
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:cutColor}];
    
    _pricedLabel.attributedText = attrStr;
    
}
@end
