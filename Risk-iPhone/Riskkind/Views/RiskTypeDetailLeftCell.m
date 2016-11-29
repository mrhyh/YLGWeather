//
//  RiskTypeDetailLeftCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypeDetailLeftCell.h"
#import "UIUtil.h"

@interface RiskTypeDetailLeftCell ()

@property (nonatomic, strong) KYMHLabel *medicinalNameLabel;
@property (nonatomic, strong) KYMHLabel *medicinalTypeLabel;

@property (nonatomic, strong) UIView *oneLineView;

@property (nonatomic, strong) KYMHLabel *medicinalTypeNumLabel;
@property (nonatomic, strong) KYMHLabel *medicinalTimeLabel;
@property (nonatomic, strong) KYMHLabel *staticOtherNameLabel;
@property (nonatomic, strong) KYMHLabel *otherNameLabel;

@property (nonatomic, strong) UIView *twoLineView;

@property (nonatomic, strong) KYMHLabel *staticDisclaimerLabel;
@property (nonatomic, strong) KYMHLabel *disclaimerLabel;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation RiskTypeDetailLeftCell {
    
    CGFloat spaceToLeft;
    CGFloat fontSize;
    CGFloat labelH;
    CGFloat toTopSpace;
    CGFloat labelW;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setup {
    
    spaceToLeft = 15;
    fontSize = smallFontSize;
    labelH = 20;
    toTopSpace = 10;
    labelW = SCREEN_WIDTH-2*spaceToLeft;

    _medicinalNameLabel = [KYMHLabel new];
    _medicinalNameLabel.font = Font(fontSize);
    _medicinalNameLabel.textColor = EF_TextColor_TextColorPrimary;
    _medicinalNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _medicinalTypeLabel = [KYMHLabel new];
    _medicinalTypeLabel.font = Font(fontSize);
    _medicinalTypeLabel.textColor = EF_TextColor_TextColorSecondary;
    _medicinalTypeLabel.textAlignment = NSTextAlignmentLeft;
    
    _oneLineView = [UIView new];
    _oneLineView.backgroundColor =  EF_TextColor_TextColorDisable;
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = [UIColor whiteColor];
    
    _medicinalTypeNumLabel = [KYMHLabel new];
    _medicinalTypeNumLabel.font = Font(fontSize);
    _medicinalTypeNumLabel.textColor = EF_TextColor_TextColorSecondary;
    _medicinalTypeNumLabel.textAlignment = NSTextAlignmentLeft;
    
    _medicinalTimeLabel = [KYMHLabel new];
    _medicinalTimeLabel.font = Font(fontSize);
    _medicinalTimeLabel.textColor = EF_TextColor_TextColorSecondary;
    _medicinalTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    _staticOtherNameLabel = [KYMHLabel new];
    _staticOtherNameLabel.font = Font(fontSize);
    _staticOtherNameLabel.textColor = EF_TextColor_TextColorPrimary;
    _staticOtherNameLabel.textAlignment = NSTextAlignmentLeft;
    
    _otherNameLabel = [KYMHLabel new];
    _otherNameLabel.font = Font(fontSize);
    _otherNameLabel.textColor = EF_TextColor_TextColorSecondary;
    _otherNameLabel.textAlignment = NSTextAlignmentLeft;
    
    
    _twoLineView = [UIView new];
    _twoLineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    _staticDisclaimerLabel = [KYMHLabel new];
    _staticDisclaimerLabel.font = Font(fontSize);
    _staticDisclaimerLabel.textColor = EF_TextColor_TextColorPrimary;
    _staticDisclaimerLabel.textAlignment = NSTextAlignmentLeft;
    
    _disclaimerLabel = [KYMHLabel new];
    _disclaimerLabel.font = Font(fontSize);
    _disclaimerLabel.textColor = EF_TextColor_TextColorSecondary;
    _disclaimerLabel.textAlignment = NSTextAlignmentLeft;
    
    
    NSArray *views = @[ _medicinalNameLabel, _medicinalTypeLabel, _oneLineView, _bottomLineView, _medicinalTypeNumLabel, _medicinalTimeLabel, _staticOtherNameLabel, _otherNameLabel, _twoLineView, _staticDisclaimerLabel, _disclaimerLabel];
    
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _medicinalNameLabel.sd_layout
    .topSpaceToView(contentView, 20)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _medicinalTypeLabel.sd_layout
    .topSpaceToView(_medicinalNameLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _oneLineView.sd_layout
    .topSpaceToView(_medicinalTypeLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(0.5);
    
    _medicinalTypeNumLabel.sd_layout
    .topSpaceToView(_oneLineView, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _medicinalTimeLabel.sd_layout
    .topSpaceToView(_medicinalTypeNumLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _staticOtherNameLabel.sd_layout
    .topSpaceToView(_medicinalTimeLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _otherNameLabel.sd_layout
    .topSpaceToView(_staticOtherNameLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .autoHeightRatio(0);
    
    _twoLineView.sd_layout
    .topSpaceToView(_otherNameLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(0.5);
    
    
    _staticDisclaimerLabel.sd_layout
    .topSpaceToView(_twoLineView, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _disclaimerLabel.sd_layout
    .topSpaceToView(_staticDisclaimerLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .autoHeightRatio(0);
    
    _bottomLineView.sd_layout
    .topSpaceToView(_disclaimerLabel, toTopSpace)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(labelW)
    .heightIs(0.5);
}


- (void) setModel:(RSRiskDetailModel *)model {
    
    _model = model;
    
    _medicinalNameLabel.text = model.name;

    NSString *catName = [[NSString alloc] init];
    catName = model.categoryShowName;
    if ( ![UIUtil isEmptyStr:model.fdaType] ) {
        catName = [NSString stringWithFormat:@"%@  FDA分类:  %@",model.categoryShowName, model.fdaType];
    }
    _medicinalTypeLabel.text = catName;
    
    UIColor *medicinalTypeNumLabelColor = EF_TextColor_TextColorPrimary;
    NSMutableAttributedString *medicinalTypeNumString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"分类编号: %@",model.riskCode]];
    [medicinalTypeNumString setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15], NSForegroundColorAttributeName: medicinalTypeNumLabelColor} range:NSMakeRange(0, 5)];
    _medicinalTypeNumLabel.attributedText = medicinalTypeNumString;
    
    
    long long time = model.updateTime;
    NSDate * data = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSString *timeString = [UIUtil prettyDateChangeWithReference:data setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableAttributedString *medicinalTimeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"更新时间: %@",timeString]];
    [medicinalTimeString setAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15], NSForegroundColorAttributeName: medicinalTypeNumLabelColor} range:NSMakeRange(0, 5)];
    _medicinalTimeLabel.attributedText = medicinalTimeString;
    
    _staticOtherNameLabel.text = @"其他名称: ";
    _otherNameLabel.text = model.otherName;

    _staticDisclaimerLabel.text = @"免责声明: ";
    _disclaimerLabel.text = model.declare;

    //cell高度适配
    UIView *bottomView;
    bottomView = _bottomLineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

@end