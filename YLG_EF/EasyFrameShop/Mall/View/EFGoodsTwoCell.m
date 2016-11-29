//
//  EFGoodsTwoCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFGoodsTwoCell.h"
#import "EFMailNS_Enum.h"
#import "AppDelegate+Payment.h"
@interface EFGoodsTwoCell () {
    
    EFGoodsTwoCellButtonClickBlock efGoodsTwoCellRightButtonClickBlock;
    EFGoodsTwoCellButtonClickBlock efGoodsTwoCellLeftButtonClickBlock;
}

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *priceLabel; //一种商品的总金额
@property (nonatomic, strong) KYMHLabel *numLabel; //商品数量
@property (nonatomic, strong) KYMHLabel *staticLabel; //“总计”文本
@property (nonatomic, strong) KYMHLabel *sumLabel; //总金额
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) NSInteger orderStatusInteger;

@end

@implementation EFGoodsTwoCell {
    CGFloat nameFontSize;
    CGFloat priceFontSize;
    CGFloat sumLabelFontSize;
    CGFloat spaceToLeft;
    
    UIColor *canSelectColor;
    UIColor *noCanSelectColor;
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
    _orderStatusInteger = 0;
    
    canSelectColor = RGBColor(25, 182, 23);
    noCanSelectColor = RGBColor(175, 176, 175);
    
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
    
    
    _staticLabel = [KYMHLabel new];
    _staticLabel.textColor = EF_TextColor_TextColorPrimary;
    _staticLabel.textAlignment = NSTextAlignmentLeft;
    _staticLabel.font = Font(15);
    _staticLabel.text = @"总计";
    
    _sumLabel = [KYMHLabel new];
    _sumLabel.textColor = EF_TextColor_TextColorPrimary;
    _sumLabel.textAlignment = NSTextAlignmentRight;
    _sumLabel.font = Font(sumLabelFontSize);
    _sumLabel.text = @"￥928";
    _sumLabel.text = [NSString stringWithFormat:@"￥%ld",(long)self.sumPrice];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = RGBColor(246, 246, 246);
    
    _leftButton = [KYMHButton new];
    [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftCancelOrder) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.backgroundColor = canSelectColor;
    _leftButton.layer.cornerRadius = 5;
    _leftButton.titleLabel.font = Font(14);
    
    
    _rightButton = [KYMHButton new];
    [_rightButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightPayment) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.backgroundColor = RGBColor(25, 182, 23);
    _rightButton.titleLabel.font = Font(14);
    _rightButton.layer.cornerRadius = 5;
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = RGBColor(239, 244, 248);
    
    
    //布局
    NSArray *views = @[_goodImageView, _nameLabel, _priceLabel, _numLabel, _staticLabel, _sumLabel, _lineView, _leftButton, _rightButton, _bottomLineView];
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
    
    _staticLabel.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(_goodImageView, 20)
    .heightIs(20)
    .widthIs(40);
    
    _sumLabel.sd_layout
    .rightSpaceToView (contentView,spaceToLeft)
    .topSpaceToView(_goodImageView, 20)
    .heightIs(20);
    [_sumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    _lineView.sd_layout
    .topSpaceToView(_staticLabel, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(2);
    
    _rightButton.sd_layout
    .topSpaceToView(_lineView, 8)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(79)
    .heightIs(28);
    
    _leftButton.sd_layout
    .topSpaceToView(_lineView, 8)
    .rightSpaceToView(_rightButton, 8)
    .widthIs(79)
    .heightIs(28);
    
    _bottomLineView.sd_layout
    .topSpaceToView(_rightButton, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(9);
}


- (void) setSumPriceInteger:(NSInteger *)sumPriceInteger {
    _sumPriceInteger = sumPriceInteger;
    _sumLabel.text = [NSString stringWithFormat:@"￥%ld",(long)sumPriceInteger];
}

- (void) setOrderStatus:(NSString *)orderStatus {
    
    if([orderStatus isEqualToString:@"UN_PAYED"]) {
        
        [_rightButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _leftButton.backgroundColor = canSelectColor;
         _rightButton.backgroundColor = canSelectColor;
        _rightButton.hidden = NO;
        _leftButton.hidden = NO;
        _rightButton.enabled = YES;
        _rightButton.enabled = YES;
        
    }else if ([orderStatus isEqualToString:@"SHIPPED"]) {
        
        [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
        _rightButton.backgroundColor = canSelectColor;
        _rightButton.hidden = NO;
        _rightButton.enabled = YES;
        _leftButton.hidden = YES;
        
    } else if ([orderStatus isEqualToString:@"UN_COMMENTED"] || [orderStatus isEqualToString:@"APPLY_AFTER_SALE"]) {
        
        [_rightButton setTitle:@"评价" forState:UIControlStateNormal];
        [_leftButton setTitle:@"申请售后" forState:UIControlStateNormal];
        _leftButton.backgroundColor =  canSelectColor;
        _rightButton.backgroundColor = canSelectColor;
        _rightButton.hidden = NO;
        _leftButton.hidden = NO;
        _rightButton.enabled = YES;
        _leftButton.enabled = YES;
        
    }else if([orderStatus isEqualToString:@"CANCELD"]) {
        _rightButton.hidden = NO;
        [_rightButton setTitle:@"已取消" forState:UIControlStateNormal];
        _rightButton.backgroundColor = noCanSelectColor;
        _rightButton.enabled = NO;
        _leftButton.hidden = YES;
        
        
    }else if( [orderStatus isEqualToString:@"UN_SHIP"] ) {
        _rightButton.hidden = NO;
        _leftButton.hidden = YES;
        [_rightButton setTitle:@"待发货" forState:UIControlStateNormal];
        _rightButton.enabled = NO;
        _rightButton.backgroundColor = noCanSelectColor;
        
    }else if( [orderStatus isEqualToString:@"FINISHED"] ) {
        _rightButton.hidden = NO;
        _leftButton.hidden = YES;
        
        _rightButton.enabled = YES;
        [_rightButton setTitle:@"已完成" forState:UIControlStateNormal];
        _rightButton.backgroundColor = noCanSelectColor;
    }
}

- (void)setOrderproductModel:(OrderproductModel *)orderproductModel {
    if(_orderproductModel.image != nil) {
        //[_goodImageView sd_setImageWithURL:[NSURL URLWithString:orderproductModel.image.url]];
    }
    _nameLabel.text = orderproductModel.name;
    _priceLabel.text = [NSString stringWithFormat:@"%ld",(long)orderproductModel.price];
    _numLabel.text = [NSString stringWithFormat:@"￥%ld",(long)orderproductModel.quantity];
}

- (void)EFGoodsTwoCellRightButton:(EFGoodsTwoCellButtonClickBlock)block {
    efGoodsTwoCellRightButtonClickBlock = block;
}

- (void)EFGoodsTwoCellLeftButton:(EFGoodsTwoCellButtonClickBlock)block {
    efGoodsTwoCellLeftButtonClickBlock = block;
}


- (void)rightPayment{

    if (efGoodsTwoCellRightButtonClickBlock) {
        efGoodsTwoCellRightButtonClickBlock(1);
    }

}
- (void)leftCancelOrder {

    if (efGoodsTwoCellLeftButtonClickBlock) {
        efGoodsTwoCellLeftButtonClickBlock(1);
    }
}

- (void)setSumPrice:(NSInteger)sumPrice {
    _sumPrice = sumPrice;
    _sumLabel.text = [NSString stringWithFormat:@"￥%ld",(long)self.sumPrice];
}

@end
