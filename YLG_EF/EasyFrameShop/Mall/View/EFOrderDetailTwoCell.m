//
//  EFGoodsTwoCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderDetailTwoCell.h"


@interface EFOrderDetailTwoCell ()

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *priceLabel; //一种商品的总金额
@property (nonatomic, strong) KYMHLabel *numLabel; //商品数量
@property (nonatomic, strong) KYMHLabel *staticLabel; //“总计”文本
@property (nonatomic, strong) KYMHLabel *sumLabel; //总金额
@property (nonatomic, strong) UIView *lineView;

@end

@implementation EFOrderDetailTwoCell {
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

- (void)awakeFromNib {
    // Initialization code
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
    
    
    _staticLabel = [KYMHLabel new];
    _staticLabel.textColor = EF_TextColor_TextColorPrimary;
    _staticLabel.textAlignment = NSTextAlignmentLeft;
    _staticLabel.font = Font(15);
    _staticLabel.text = @"实付款";
    
    _sumLabel = [KYMHLabel new];
    _sumLabel.textColor = EF_TextColor_TextColorPrimary;
    _sumLabel.textAlignment = NSTextAlignmentLeft;
    _sumLabel.font = Font(sumLabelFontSize);
    //[_sumLabel FontWeight:10];
    _sumLabel.text = @"￥928";
    
    _lineView = [UIView new];
    _lineView.backgroundColor = RGBColor(246, 246, 246);
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = RGBColor(239, 244, 248);
    
    
    //布局
    NSArray *views = @[_goodImageView, _nameLabel, _priceLabel, _numLabel, _staticLabel, _sumLabel, _lineView, _bottomLineView];
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
    .widthIs(SCREEN_WIDTH)
    .heightIs(1);
    
    _staticLabel.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(_lineView, 15)
    .heightIs(20)
    .widthIs(70);
    
    _sumLabel.sd_layout
    .rightSpaceToView (contentView,spaceToLeft)
    .topSpaceToView(_lineView, 12)
    .heightIs(20);
    [_sumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    _bottomLineView.sd_layout
    .topSpaceToView(_staticLabel, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(9);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
