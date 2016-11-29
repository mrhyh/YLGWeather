//
//  EFMallDetailsTopCell.m
//  EF_MallDemo
//
//  Created by MH on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMallDetailsTopCell.h"
#import "StarView.h"
#import "EFCarousel.h"
#import "EFCarouselObject.h"
#import "HYDImageCategory.h"
const CGFloat titleDTLabelFontSize = 15;
CGFloat maxTitleDTLabelHeight = 0;
@implementation EFMallDetailsTopCell{
    UILabel * _titleLabel;
    UILabel * _priceLabel;
    UILabel * _pricedLabel;
    UILabel * _countLabel;
    UILabel * _pointLabel;
    KYMHButton * _button;
    UIView   *_line;
    StarView * star;
    EFCarousel * carousel;
    NSMutableArray * arr;
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
    
   
    
    
    carousel = [[EFCarousel alloc] init];
    carousel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
    carousel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
    carousel.iGCarouselSelectedBlock = ^(NSInteger index , EFCarouselObject *carouselObject){
        NSString * url = @"";
        if (carouselObject.pushURL) {
            url = carouselObject.pushURL;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    };
    


    
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:titleDTLabelFontSize];
    _titleLabel.textColor = EF_TextColor_TextColorPrimary;
//    _titleLabel.text = @"Oral-B 欧乐 D20.525.4X 4000 3D自能电动牙刷";
    if (maxTitleDTLabelHeight == 0) {
        maxTitleDTLabelHeight = _titleLabel.font.lineHeight * 3;
    }
    
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:15];
//    _priceLabel.text = @"¥599";
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.textColor = [UIColor grayColor];
    
    _pricedLabel = [UILabel new];
    _pricedLabel.textAlignment = NSTextAlignmentLeft;
//    NSAttributedString *attrStr =
//    [[NSAttributedString alloc]initWithString:@"原价1299"
//                                   attributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:13],
//       NSForegroundColorAttributeName:cutColor,
//       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
//       NSStrikethroughColorAttributeName:cutColor}];
//    
//    _pricedLabel.attributedText = attrStr;
    
    
    _countLabel = [UILabel new];
    _countLabel.font = [UIFont systemFontOfSize:15];
//    _countLabel.text = @"已售 275";
    _countLabel.textAlignment = NSTextAlignmentLeft;
    _countLabel.textColor = [UIColor grayColor];
    
    
   NSString * _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame_" ofType:@"plist"];
    //如果没有创建EasyFrame_.plist文件，那么直接加载框架内部自带的
    if (_plistPath == nil) {
        _plistPath = [[NSBundle mainBundle] pathForResource:@"EasyFrame" ofType:@"plist"];
    }

    BOOL isStock = [[[NSDictionary alloc] initWithContentsOfFile:_plistPath][@"Mall"][@"isStock"] boolValue];
    if (isStock) {
        _countLabel.hidden = NO;
    }else{
        _countLabel.hidden = YES;
    }
   
    
    _line = [UIView new];
    _line.backgroundColor = EF_TextColor_TextColorDisable;
    
    
    star = [[StarView alloc] init];
//    star.starLevel = 3.5;
    star.isTouchaAailable = NO;
    star.starScale = 0.5;
    
    _pointLabel = [UILabel new];
    _pointLabel.font = [UIFont systemFontOfSize:15];
//    _pointLabel.text = @"评分： 3.5";
    _pointLabel.textAlignment = NSTextAlignmentLeft;
    _pointLabel.textColor = [UIColor grayColor];
    
    
    UIColor * color = EF_MainColor;
    _button = [KYMHButton new];
//    [_button setTitle:@"50个评价" forState:0];
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/Disclosure Indicator"]];
    [_button setImage:image forState:0];
    [_button setTitleColor:color forState:0];
    _button.titleLabel.font = [UIFont systemFontOfSize:13];
    [_button addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_button horizontalCenterTitleAndImageRight:85];
    
    

    
    NSArray *views = @[carousel, _titleLabel, _priceLabel, _pricedLabel, _countLabel, _line ,star , _pointLabel, _button];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    
    carousel.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(160);
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(carousel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    
    _priceLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_titleLabel, margin)
    .heightIs(20);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:80*SCREEN_W_RATE];
    
    
    _pricedLabel.sd_layout
    .leftSpaceToView(_priceLabel, margin)
    .topSpaceToView(_titleLabel, margin)
    .heightIs(20);
    [_pricedLabel setSingleLineAutoResizeWithMaxWidth:120*SCREEN_W_RATE];
    
    _countLabel.sd_layout
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_titleLabel, margin)
    .heightIs(20);
    [_countLabel setSingleLineAutoResizeWithMaxWidth:120*SCREEN_W_RATE];
    
    _line.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_priceLabel, margin)
    .heightIs(0.5)
    .widthIs(SCREEN_WIDTH-10);
    
    star.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_line, margin)
    .heightIs(20)
    .widthIs(100);
    
    _pointLabel.sd_layout
    .leftSpaceToView(star, margin)
    .topSpaceToView(_line, margin)
    .heightIs(20);
    [_pointLabel setSingleLineAutoResizeWithMaxWidth:120*SCREEN_W_RATE];
    
    _button.sd_layout
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_line, margin)
    .widthIs(90*SCREEN_W_RATE)
    .heightIs(20);
    
    
}


- (void)commentButtonClicked{
    if (self.commentButtonClickedBlock) {
        self.commentButtonClickedBlock(self.indexPath);
    }
}

#pragma mark --- setter
- (void)setProductDetail:(ProductDetailModel *)productDetail{
    _productDetail = productDetail;
    _titleLabel.text = productDetail.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%zd",productDetail.price];
    UIColor * cutColor =  EF_TextColor_TextColorDisable;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价%zd",productDetail.marketPrice]attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:cutColor,NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:cutColor}];
    _pricedLabel.attributedText = attrStr;
    _countLabel.text = [NSString stringWithFormat:@"库存  %zd",productDetail.stock];
    _pointLabel.text = [NSString stringWithFormat:@"评分： %.1f",productDetail.score];
    [_button setTitle:[NSString stringWithFormat:@"%@个评价",productDetail.scoreCount > 999 ? @"999+" :[NSString stringWithFormat:@"%zd",productDetail.scoreCount]] forState:0];
    [arr removeAllObjects];
     arr = [NSMutableArray array];
    star.starLevel = productDetail.score;
    for (int i = 0; i < _productDetail.images.count; i++) {
        Image * model = _productDetail.images[i];
        EFCarouselObject *object = [[EFCarouselObject alloc] init];
        object.imageURL = model.url;
        [arr addObject:object];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        carousel.carouselList = arr;
        [carousel reloadCarousel];
    });
}
@end
