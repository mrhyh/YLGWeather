//
//  EFOrderConfirmCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderConfirmCell.h"

@interface EFOrderConfirmCell ()

@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *priceLabel; //一种商品的总金额
@property (nonatomic, strong) KYMHLabel *numLabel; //商品数量

@end

@implementation EFOrderConfirmCell {
    
    CGFloat nameFontSize;
    CGFloat priceFontSize;
    CGFloat sumLabelFontSize;
    CGFloat spaceToLeft;

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//1. 创建控件
- (void)setup{
    
    spaceToLeft = 10;
    
    nameFontSize = 13;
    priceFontSize = 14;
    sumLabelFontSize = 16;
    
    //初始化控件
    
    _nameLabel = [KYMHLabel new];
    _nameLabel.textColor = EF_TextColor_TextColorPrimary;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = @"Lebond 电动牙刷三合一";
    _nameLabel.font = Font(nameFontSize);
    
    
    _priceLabel = [KYMHLabel new];
    _priceLabel.textColor = EF_TextColor_TextColorPrimary;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = Font(priceFontSize);
    _priceLabel.text = @"￥599";
    
    _numLabel = [KYMHLabel new];
    _numLabel.textColor = EF_TextColor_TextColorSecondary;
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = Font(nameFontSize);
    _numLabel.text = @"x1";
    
    _lineView = [UIView new];
    _lineView.backgroundColor = RGBColor(246, 246, 246);
    
    //布局
    NSArray *views = @[_nameLabel, _priceLabel, _numLabel, _lineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _nameLabel.sd_layout
    .leftSpaceToView (contentView, spaceToLeft)
    .topSpaceToView (contentView, spaceToLeft)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    
    _numLabel.sd_layout
    .rightSpaceToView(contentView, spaceToLeft)
    .topSpaceToView (contentView, spaceToLeft)
    .heightIs(20);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    _priceLabel.sd_layout
    .rightSpaceToView(_numLabel, spaceToLeft)
    .topSpaceToView (contentView, spaceToLeft)
    .heightIs(20);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    _lineView.sd_layout
    .topSpaceToView(_nameLabel, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH-2*spaceToLeft)
    .heightIs(2);
}

- (void)setShopCartContentModel:(ShopCartContentModel *)shopCartContentModel {
    
    _nameLabel.text = shopCartContentModel.productItem.name;
    _priceLabel.text = [NSString stringWithFormat:@"%ld￥",shopCartContentModel.productItem.price];
    _numLabel.text = [NSString stringWithFormat:@"x%ld",(long)shopCartContentModel.quantity];
}
@end
