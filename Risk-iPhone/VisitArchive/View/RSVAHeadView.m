//
//  RSVAHeadView.m
//  Risk
//
//  Created by ylgwhyh on 16/7/27.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVAHeadView.h"
#import "RSVAArchivesModel.h"

@implementation RSVAHeadView {
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
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    _numberLabel = [self createLabelWithX:0 width:60];
    _medicalRecordNumLabel = [self createLabelWithX:60 width:115];
    _nameLabel = [self createLabelWithX:175 width:75];
    _phoneNumLabel = [self createLabelWithX:250 width:115];
    _mensesDataLabel = [self createLabelWithX:365 width:95];
    _estimateTimeLabel = [self createLabelWithX:460 width:95];
    _pregnantTimeLabel = [self createLabelWithX:555 width:55];
    _babyNumberLabel = [self createLabelWithX:610 width:55];
    _exposureFactorLabel = [self createLabelWithX:665 width:SCREEN_WIDTH-665];
    
    NSArray *views = @[_topLineView,  _numberLabel, _medicalRecordNumLabel, _nameLabel,_phoneNumLabel,  _mensesDataLabel, _estimateTimeLabel, _pregnantTimeLabel ,_babyNumberLabel, _exposureFactorLabel, _bottomLineView];
    
    UIView *contentView = self;
    
    [contentView sd_addSubviews:views];
    
    _topLineView.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    
    _bottomLineView.sd_layout
    .bottomSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    [_bottomLineView bringSubviewToFront:contentView];
    [_topLineView bringSubviewToFront:contentView];
    
    self.backgroundColor = RGBColor(248, 249, 248);
}

- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH)];
    lineView.backgroundColor = EF_TextColor_TextColorDisable;
    [label addSubview:lineView];
    
    return label;
}

- (void ) initData {
    
    RSVAArchivesModel *model = [[RSVAArchivesModel alloc] init];
    model.numberInteger = 0;
    model.nameString = @"姓名";
    model.medicalRecordNumString = @"病历号";
    
    model.phoneNumString = @"电话";
    model.mensesDataString = @"月经末期";
    model.estimateTimeString = @"预产期";
    
    model.pregnantTimesString = @"孕次";
    model.babyNumberString = @"产次";
    model.exposureFactorString = @"暴露因素名称";
    
    _medicalRecordNumLabel.text = model.medicalRecordNumString;
    _nameLabel.text = model.nameString;
    _phoneNumLabel.text = model.phoneNumString;
    _mensesDataLabel.text = model.mensesDataString;
    _estimateTimeLabel.text = model.estimateTimeString;
    _pregnantTimeLabel.text = model.pregnantTimesString;
    _babyNumberLabel.text = model.babyNumberString;
    _exposureFactorLabel.text = model.exposureFactorString;

}

@end
