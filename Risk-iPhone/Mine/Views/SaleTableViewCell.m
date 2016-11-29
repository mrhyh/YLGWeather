//
//  SaleTableViewCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/31.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "SaleTableViewCell.h"

@implementation SaleTableViewCell {
    UILabel * fileNameLB;
    UILabel * patientNameLB;
    UILabel * priceLB;
    UILabel * saleTimeLB;
    UIView  * line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier    {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    fileNameLB = [UILabel new];
    fileNameLB.backgroundColor = [UIColor clearColor];
    fileNameLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    fileNameLB.font = Font(15);
    fileNameLB.textAlignment = NSTextAlignmentLeft;
    
    patientNameLB = [UILabel new];
    patientNameLB.backgroundColor = [UIColor clearColor];
    patientNameLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    patientNameLB.font = Font(13);
    patientNameLB.textAlignment = NSTextAlignmentLeft;
    
    priceLB = [UILabel new];
    priceLB.backgroundColor = [UIColor clearColor];
    priceLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    priceLB.font = Font(13);
    priceLB.textAlignment = NSTextAlignmentLeft;
    
    saleTimeLB = [UILabel new];
    saleTimeLB.backgroundColor = [UIColor clearColor];
    saleTimeLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    saleTimeLB.font = Font(13);
    saleTimeLB.textAlignment = NSTextAlignmentRight;
    
    line = [UIView new];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    UIView * contentView =  self.contentView;
    NSArray * views = @[fileNameLB,patientNameLB,priceLB,saleTimeLB,line];
    [contentView sd_addSubviews:views];
    
    fileNameLB.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);
    
    patientNameLB.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(fileNameLB,5)
    .heightIs(20);
    [patientNameLB setSingleLineAutoResizeWithMaxWidth:200];
    
    priceLB.sd_layout
    .rightSpaceToView(contentView,10)
    .topSpaceToView(fileNameLB,5)
    .heightIs(20);
    [priceLB setSingleLineAutoResizeWithMaxWidth:200];
    
    saleTimeLB.sd_layout
    .rightSpaceToView(contentView,10)
    .topSpaceToView(priceLB,5)
    .heightIs(20);
    [saleTimeLB setSingleLineAutoResizeWithMaxWidth:250];
    
    line.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(saleTimeLB,5)
    .heightIs(0.5);
    
}

- (void)setModel:(RecordList *)model {
    _model = model;
    
    fileNameLB.text = _model.fileName;
    patientNameLB.text = [NSString stringWithFormat:@"购买人：%@",_model.patientName];
    priceLB.text = [NSString stringWithFormat:@"单价：%.2f",_model.price];
    saleTimeLB.text = _model.saleTime;
    
    //适配
    UIView *bottomView;
    bottomView = line;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
