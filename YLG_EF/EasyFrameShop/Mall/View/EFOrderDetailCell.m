//
//  EFOrderDetailCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderDetailCell.h"

@interface EFOrderDetailCell ( )

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *priceLabel; //一种商品的总金额
@property (nonatomic, strong) KYMHLabel *numLabel; //商品数量
@property (nonatomic, strong) UIView *lineView;

@end

@implementation EFOrderDetailCell {
    
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
    _goodImageView = [KYMHImageView new];
    _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    _goodImageView.clipsToBounds = YES;
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:@"https://gss0.baidu.com/80M_cCml_AoJksuboYuT_XF5eBk7hKzk-cq/bos_1464854088.34_341405_24886.jpg@w_225"]];
    
    
    _nameLabel = [KYMHLabel new];
    _nameLabel.textColor = EF_TextColor_TextColorPrimary;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    //_nameLabel.text = @"Lebond 电动牙刷三合一";
    _nameLabel.font = Font(nameFontSize);
    
    
    _priceLabel = [KYMHLabel new];
    _priceLabel.textColor = EF_TextColor_TextColorPrimary;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = Font(priceFontSize);
    //_priceLabel.text = @"￥599";
    
    
    _numLabel = [KYMHLabel new];
    _numLabel.textColor = EF_TextColor_TextColorSecondary;
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = Font(nameFontSize);
    //_numLabel.text = @"x1";
    
    _lineView = [UIView new];
    _lineView.backgroundColor = RGBColor(246, 246, 246);
    
    //布局
    NSArray *views = @[_goodImageView, _nameLabel, _priceLabel, _numLabel, _lineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _goodImageView.sd_layout
    .leftSpaceToView (contentView, spaceToLeft)
    .topSpaceToView (contentView, spaceToLeft)
    .widthIs(57)
    .heightIs(57);
    
    _nameLabel.sd_layout
    .leftSpaceToView (_goodImageView, spaceToLeft)
    .topEqualToView(_goodImageView)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    _priceLabel.sd_layout
    .rightSpaceToView(contentView, spaceToLeft)
    .topEqualToView(_nameLabel)
    .heightIs(20);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    
    _numLabel.sd_layout
    .rightSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(_priceLabel, 8)
    .heightIs(20);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    _lineView.sd_layout
    .topSpaceToView(_goodImageView, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH-2*spaceToLeft)
    .heightIs(2);
    
}

- (void)setOrderproductModel:(OrderproductModel *)orderproductModel {
    
    if(_orderproductModel.image != nil) {
        [_goodImageView sd_setImageWithURL:[NSURL URLWithString:orderproductModel.image.url]];
    }
    _nameLabel.text = orderproductModel.name;
    _priceLabel.text = [NSString stringWithFormat:@"%ldx",(long)orderproductModel.price];
    _numLabel.text = [NSString stringWithFormat:@"￥%ld",(long)orderproductModel.quantity];
}
@end
