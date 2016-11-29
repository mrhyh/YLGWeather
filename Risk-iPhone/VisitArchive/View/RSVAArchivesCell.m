//
//  RSVAArchivesCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/6.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVAArchivesCell.h"
#import "RSFollowUpRecordModel.h"
#import "RSMethod.h"
#import "UIUtil.h"

@interface RSVAArchivesCell ()

@property (nonatomic, strong) KYMHLabel *numberLabel;
@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel; //病历号
@property (nonatomic, strong) KYMHLabel *nameLabel; //姓名
@property (nonatomic, strong) KYMHLabel *phoneNumLabel;
@property (nonatomic, strong) KYMHLabel *mensesDataLabel; //月经末期
@property (nonatomic, strong) KYMHLabel *estimateTimeLabel; //预产期
@property (nonatomic, strong) KYMHLabel *pregnantTimeLabel; //孕次
@property (nonatomic, strong) KYMHLabel *babyNumberLabel; //产次
@property (nonatomic, strong) KYMHLabel *exposureFactorLabel; //暴露因素名称

@end

@implementation RSVAArchivesCell {
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
    
    _medicalRecordNumLabel = [self createLabelWithX:60 width:115];
    _nameLabel = [self createLabelWithX:175 width:75];
    _phoneNumLabel = [self createLabelWithX:250 width:115];
    _mensesDataLabel = [self createLabelWithX:365 width:95];
    _estimateTimeLabel = [self createLabelWithX:460 width:95];
    _pregnantTimeLabel = [self createLabelWithX:555 width:55];
    _babyNumberLabel = [self createLabelWithX:610 width:55];
    _exposureFactorLabel = [self createLabelWithX:665 width:SCREEN_WIDTH-665];
    
    NSArray *views = @[_topLineView, _medicalRecordNumLabel, _nameLabel,_phoneNumLabel,  _mensesDataLabel, _estimateTimeLabel, _pregnantTimeLabel ,_babyNumberLabel, _exposureFactorLabel, _bottomLineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    
    //iPhone版 重新排版
    
    CGFloat spaceToLeft = 10;
    CGFloat spaceToTop = 10;
    CGFloat labelH = 20;
    
    //第一排
    _nameLabel.sd_layout
    .topSpaceToView(contentView, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(150)
    .heightIs(labelH);
    
    _medicalRecordNumLabel.sd_layout
    .topEqualToView(_nameLabel)
    .leftSpaceToView(_nameLabel, 1)
    .widthIs(1)
    .heightIs(labelH);
    
    _phoneNumLabel.sd_layout
    .topEqualToView(_nameLabel)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(120)
    .heightIs(labelH);
    
    //第二排
    _mensesDataLabel.sd_layout
    .topSpaceToView(_nameLabel,spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH/5*2)
    .heightIs(labelH);
    
    _estimateTimeLabel.sd_layout
    .topEqualToView(_mensesDataLabel)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH/5*2)
    .heightIs(labelH);
    
    //第三次
    _pregnantTimeLabel.sd_layout
    .topSpaceToView(_mensesDataLabel,spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH/5*2)
    .heightIs(labelH);
    
    _babyNumberLabel.sd_layout
    .topEqualToView(_pregnantTimeLabel)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH/5*2)
    .heightIs(labelH);
    
    _bottomLineView.sd_layout
    .topSpaceToView(_pregnantTimeLabel, 10)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
 
//    [_bottomLineView bringSubviewToFront:self.contentView];
//    [_topLineView bringSubviewToFront:self.contentView];
}


- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, 20) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentCenter];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH)];
//    lineView.backgroundColor = EF_TextColor_TextColorDisable;
//    [label addSubview:lineView];
    
    return label;
}


- (void) setModel:(RSVisitArchiveModel *)model {
    
    _model = model;
    
    if(_numberInteger != 0) {
        _numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_numberInteger];
    }

     _nameLabel.text = [NSString stringWithFormat:@"%@/%@", model.name, model.medicalRecordNo];
    _phoneNumLabel.text = model.phoneNum;
    _mensesDataLabel.text = [NSString stringWithFormat:@"月经末期: %@", [RSMethod returnDateStringWithTimestamp:model.menstruationTime]];
    _estimateTimeLabel.text = [NSString stringWithFormat:@"预产期:  %@", [RSMethod returnDateStringWithTimestamp:model.childbirthTime]];
    _pregnantTimeLabel.text = [NSString stringWithFormat:@"孕次: %@",model.pregnancyNum];
    _babyNumberLabel.text = [NSString stringWithFormat:@"产次: %@",model.bornNum];
    
    NSString *exposureFactorLabelString = [NSString new];
    for (int i=0; i<model.patientRisks.count; i++ ) {
        PatientrisksModel *prModel = model.patientRisks[i];
        
        NSString *str = [NSString new];
        NSString *timeStr = [NSString new];
        
        if ([UIUtil isEmptyStr:prModel.startTime] && [UIUtil isEmptyStr:prModel.endTime] ) {
            timeStr = @"";
        }else if ( [UIUtil isNoEmptyStr:prModel.startTime] && ([UIUtil isNoEmptyStr:prModel.endTime]) ) {
            timeStr = [NSString stringWithFormat:@"(%@-%@)", [RSMethod returnDateStringWithTimestamp:prModel.startTime], [RSMethod returnDateStringWithTimestamp:prModel.endTime]];
        }else if ([UIUtil isNoEmptyStr:prModel.startTime]) {
            timeStr = [NSString stringWithFormat:@"(%@)  ",[RSMethod returnDateStringWithTimestamp:prModel.startTime]];
        }
        
        if (0 == i ) {
            str = [NSString stringWithFormat:@"%@%@",prModel.riskName,timeStr];
        }else {
            str = [NSString stringWithFormat:@"、%@%@",prModel.riskName, timeStr];
        }
        exposureFactorLabelString = [exposureFactorLabelString stringByAppendingString:str];
    }
    _exposureFactorLabel.text = exposureFactorLabelString;

    //cell高度适配
    UIView *bottomView;
    bottomView = _bottomLineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

@end