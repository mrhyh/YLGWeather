//
//  EFPushCommentCell.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/21.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFPushCommentCell.h"
#import "StarView.h"
#import <IQTextView.h>

@interface EFPushCommentCell()<UITextViewDelegate>
//产品图片
@property (nonatomic, weak) UIImageView *productImageView;
//产品名称
@property (nonatomic, weak) UILabel *productNameLabel;
//产品价格
@property (nonatomic, weak) UILabel *productPriceLabel;
//产品数量
@property (nonatomic, weak) UILabel *productCountLabel;
//输入框
@property (nonatomic, weak) IQTextView *textView;
//评分
@property (nonatomic, weak) StarView *starView;
@end
@implementation EFPushCommentCell
#pragma mark --- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *productImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:productImageView];
    productImageView.layer.borderWidth = 1;
    productImageView.layer.borderColor = [UIColor grayColor].CGColor;
    productImageView.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).widthIs(60).heightIs(60);
    self.productImageView = productImageView;
    
    UILabel *productNameLabel = [[UILabel alloc] init];
    productNameLabel.numberOfLines = 0;
    productNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:productNameLabel];
    productNameLabel.sd_layout.topEqualToView(productImageView).leftSpaceToView(productImageView,10).autoHeightRatio(0);
    [productNameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 180];
    self.productNameLabel = productNameLabel;
    
    UILabel *productPriceLabel = [[UILabel alloc] init];
    productPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:productPriceLabel];
    productPriceLabel.sd_layout.topSpaceToView(self.contentView,25).rightSpaceToView(self.contentView,10).heightIs(20).widthIs(80);
    self.productPriceLabel = productPriceLabel;
    
    UILabel *productCountLabel = [[UILabel alloc] init];
    productCountLabel.textAlignment = NSTextAlignmentRight;
    productCountLabel.font = [UIFont systemFontOfSize:15];
    productCountLabel.textColor = EF_TextColor_TextColorSecondary;
    [self.contentView addSubview:productCountLabel];
    productCountLabel.sd_layout.topSpaceToView(productPriceLabel,5).rightSpaceToView(self.contentView,10).heightIs(20).widthIs(80);
    self.productCountLabel = productCountLabel;
    
    UIView *separateLine1  = [[UIView alloc] init];
    separateLine1.backgroundColor = RGBColor(242, 246, 250);
    [self.contentView addSubview:separateLine1];
    separateLine1.sd_layout.topSpaceToView(productImageView,10).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(1);
    
    IQTextView *textView = [[IQTextView alloc] init];
    textView.delegate = self;
    textView.placeholder = @"您对这一次的购物体验有哪些想法？您的评价很可能帮助其他的人";
    [self.contentView addSubview:textView];
    textView.sd_layout.topSpaceToView(separateLine1,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(100);
    self.textView = textView;
    
    UIView *separateLine2 = [[UIView alloc] init];
    [self.contentView addSubview:separateLine2];
    separateLine2.backgroundColor = RGBColor(242, 246, 250);
    separateLine2.sd_layout.topSpaceToView(textView,10).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(1);
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = EF_TextColor_TextColorSecondary;
    subTitleLabel.text = @"商品评分";
    subTitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:subTitleLabel];
    subTitleLabel.sd_layout.topSpaceToView(separateLine2,10).leftSpaceToView(self.contentView,10).heightIs(20);
    [subTitleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    StarView *starView = [[StarView alloc] init];
    [self.contentView addSubview:starView];
    starView.sd_layout.topSpaceToView(subTitleLabel,10).leftSpaceToView(self.contentView,10).widthIs(SCREEN_WIDTH / 3).heightIs(30);
    self.starView = starView;
    [starView addObserver:self forKeyPath:@"starLevel" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *separateLine3 = [[UIView alloc] init];
    [self.contentView addSubview:separateLine3];
    separateLine3.backgroundColor = RGBColor(242, 246, 250);
    separateLine3.sd_layout.topSpaceToView(starView,10).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(1);
}

- (void)setOrderProduct:(OrderproductModel *)orderProduct{
    _orderProduct = orderProduct;
    self.productNameLabel.text = orderProduct.name;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:self.orderProduct.image.url] placeholderImage:nil];
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥%zd",orderProduct.price];
    self.productCountLabel.text = [NSString stringWithFormat:@"X%zd",orderProduct.quantity];
    orderProduct.score = self.starView.starLevel;
}

#pragma mark --- kvc 监听控件属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.orderProduct.score = self.starView.starLevel;
}

- (void)dealloc{
    [self.starView removeObserver:self forKeyPath:@"starLevel"];
}


#pragma mark ---监听textView的改变
- (void)textViewDidChange:(UITextView *)textView{
    self.orderProduct.content = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.orderProduct.content = textView.text;
}
@end
