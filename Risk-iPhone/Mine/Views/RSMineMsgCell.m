//
//  RSMineMsgCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMineMsgCell.h"

@interface RSMineMsgCell ()

@property (nonatomic,strong) KYMHLabel * topLB;
@property (nonatomic,strong) KYMHLabel * titleLB;
@property (nonatomic,strong) KYMHLabel * contentLB;
@property (nonatomic,strong) KYMHLabel * timeLB;
@property (nonatomic,strong) UIView    * bottomLine;

@end

@implementation RSMineMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUp  {
    
    _topLB = [[KYMHLabel alloc]init];
    _topLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _topLB.font = Font(13);
    _topLB.backgroundColor = [UIColor clearColor];
    _topLB.textAlignment = NSTextAlignmentLeft;
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    _titleLB = [[KYMHLabel alloc]init];
    _titleLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _titleLB.font = Font(14);
    _titleLB.backgroundColor = [UIColor clearColor];
    _titleLB.textAlignment = NSTextAlignmentLeft;
    
    _contentLB = [[KYMHLabel alloc]init];
    _contentLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _contentLB.font = Font(13);
    _contentLB.backgroundColor = [UIColor clearColor];
    _contentLB.textAlignment = NSTextAlignmentLeft;
    
    _timeLB = [[KYMHLabel alloc]init];
    _timeLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _timeLB.font = Font(13);
    _timeLB.backgroundColor = [UIColor clearColor];
    _timeLB.textAlignment = NSTextAlignmentRight;
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = [UIColor clearColor];
    
    NSArray * views = @[_topLB,line,_titleLB,_contentLB,_timeLB,_bottomLine];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    _topLB.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,0)
    .widthIs(100)
    .heightIs(29);
    
    line.sd_layout
    .topSpaceToView(_topLB,0)
    .leftSpaceToView(contentView,10)
    .rightEqualToView(contentView)
    .heightIs(0.5);
    
    _titleLB.sd_layout
    .topSpaceToView(line,5)
    .leftSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);
    
    _contentLB.sd_layout
    .topSpaceToView(_titleLB,5)
    .leftSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);
    
    _timeLB.sd_layout
    .topSpaceToView(_contentLB,5)
    .rightSpaceToView(contentView,10)
    .widthIs(250)
    .heightIs(20);
    
    _bottomLine.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_timeLB,5)
    .heightIs(0.5);
}

- (void)setModel:(MSGContent *)model {
    _model = model;
    
    _topLB.text = _model.type;
    _titleLB.text = _model.title;
    _contentLB.text = _model.content;
    _timeLB.text = [UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",_model.sendDate]];
    
    
    UIView *bottomView;
    bottomView = _bottomLine;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

@end
