//
//  RSVAriskFactorCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVAriskFactorCell.h"
#import "RSFollowUpRecordModel.h"
#import "RSMethod.h"


@interface RSVAriskFactorCell ( ) {
    RSVAriskFactorCellHeadBlock rsVAriskFactorCellHeadBlock;
}

@property (nonatomic, strong) KYMHButton *numberButton;
@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *phoneNumLabel;

@end

@implementation RSVAriskFactorCell {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
}

- (void) setup {
    
    cellH = 44;
    textColor = EF_TextColor_TextColorPrimary;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    UIColor *buttonTitleColor = EF_TextColor_TextColorPrimary;
//    _numberButton = [[KYMHButton alloc] initWithFrame:CGRectMake(0, 0, cellH, cellH)];
//    [_numberButton setTitle:@"" forState:UIControlStateNormal];
//    [_numberButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
//    _numberButton.titleLabel.font = Font(smallFontSize);
//    _numberButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    UIView *buttonRightlineView = [[UIView alloc] initWithFrame:CGRectMake(_numberButton.frame.size.width, 0, 0.5, cellH-2)];
//    buttonRightlineView.backgroundColor = EF_TextColor_TextColorDisable;
//    [_numberButton addSubview:buttonRightlineView];
    
    
    _medicalRecordNumLabel = [self createLabelWithX:cellH width:200];
    _nameLabel = [self createLabelWithX:cellH+200 width:50];
    _phoneNumLabel = [self createLabelWithX:cellH+250 width:SCREEN_WIDTH/2-cellH-250];    
    
    NSArray *views = @[ _medicalRecordNumLabel, _nameLabel,_phoneNumLabel , _bottomLineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    CGFloat spaceToTop = 10;
    CGFloat spaceToLeft = 10;
    CGFloat labelH = 20;
    
    _nameLabel.sd_layout
    .topSpaceToView(contentView, spaceToTop)
    .rightSpaceToView(contentView, spaceToLeft)
    .widthIs(100)
    .heightIs(labelH);
    
    _medicalRecordNumLabel.sd_layout
    .topSpaceToView(contentView, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .rightSpaceToView(_nameLabel, spaceToLeft)
    .heightIs(labelH);
    
    _phoneNumLabel.sd_layout
    .topSpaceToView(_medicalRecordNumLabel, spaceToTop)
    .leftSpaceToView(contentView, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft)
    .heightIs(labelH);
    
    _bottomLineView.sd_layout
    .topSpaceToView(_phoneNumLabel, spaceToTop)
//    .bottomSpaceToView(self.cellBGView, 0)
    .leftSpaceToView(contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
}


- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentLeft];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH-2)];
//    lineView.backgroundColor = EF_TextColor_TextColorDisable;
//    [label addSubview:lineView];
    
    return label;
}

#pragma mark Set

- (void) setModel:(PatientrisksModel *)model {
    
    _model = model;
    
    NSString *string = [NSString stringWithFormat:@"%ld", (long)_numberInteger];
    [_numberButton setTitle:string forState:UIControlStateNormal];
    
    _medicalRecordNumLabel.text = [NSString stringWithFormat:@"暴露因素名称: %@",model.riskName];
    _nameLabel.text = [NSString stringWithFormat:@"剂量: %@",model.dosage];
    
    NSString *timeStr = [NSString new];

    if ([UIUtil isEmptyStr:model.startTime] && [UIUtil isEmptyStr:model.endTime] ) {
        timeStr = @"";
    }else if ( [UIUtil isNoEmptyStr:model.startTime] && ([UIUtil isNoEmptyStr:model.endTime]) ) {
        timeStr = [NSString stringWithFormat:@"(%@-%@)", [RSMethod returnDateStringWithTimestamp:model.startTime], [RSMethod returnDateStringWithTimestamp:model.endTime]];
    }else if ([UIUtil isNoEmptyStr:model.startTime]) {
        timeStr = [NSString stringWithFormat:@"%@",[RSMethod returnDateStringWithTimestamp:model.startTime]];
    }
    
    _phoneNumLabel.text =  [NSString stringWithFormat:@"暴露时间范围: %@",timeStr];
    
    //cell高度适配
    UIView *bottomView;
    bottomView = _bottomLineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

#pragma mark Button Action

- (void ) numberButtonAction: (KYMHButton *)button {
    
    button.selected = !button.selected;
    
    if(rsVAriskFactorCellHeadBlock ) {
        rsVAriskFactorCellHeadBlock(button.selected);
    }
}

- (void)RSVAriskFactorCellHeadSelectBlock:(RSVAriskFactorCellHeadBlock )block{
    
    rsVAriskFactorCellHeadBlock = block;
}

#pragma mark 重写 setEditing: animated:方法

//-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
//    
//    if (self.editing == editing)
//    {
//        return;
//    }
//    
//    [super setEditing:editing animated:animated];
//    
//    CGFloat moveSpace = 38;
//    
//    //cell本会右移，这里讲其往左边移动30，抵消编辑模式的右移距离
//    if (editing) {
//
//        [self.cellBGView setFrame:CGRectMake(self.cellBGView.frame.origin.x - moveSpace, self.cellBGView.frame.origin.y, self.cellBGView.frame.size.width, self.cellBGView.frame.size.height)];
//        }
//    else {
//        [self.cellBGView setFrame:CGRectMake(self.cellBGView.frame.origin.x + moveSpace, self.cellBGView.frame.origin.y, self.cellBGView.frame.size.width, self.cellBGView.frame.size.height)];
//    }
//}
@end