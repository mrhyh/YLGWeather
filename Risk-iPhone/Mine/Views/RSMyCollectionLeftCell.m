//
//  RSMyCollectionLeftCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/8.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMyCollectionLeftCell.h"

@interface RSMyCollectionLeftCell ()

@property (nonatomic, strong) KYMHImageView *leftImageView;
@property (nonatomic, strong) KYMHLabel *topLabel;
@property (nonatomic, strong) KYMHLabel *bottomLabel;

@end

@implementation RSMyCollectionLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setup {
    
    _leftImageView = [KYMHImageView new];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImageView.clipsToBounds = YES;
    _leftImageView.image = Img(@"search_dataImg");
    
    _topLabel = [KYMHLabel new];
    _topLabel.font = Font(smallFontSize);
    _topLabel.textColor = EF_TextColor_TextColorPrimary;
    _topLabel.textAlignment = NSTextAlignmentLeft;
    
    _bottomLabel = [KYMHLabel new];
    _bottomLabel.font = Font(smallFontSize-2);
    _bottomLabel.textColor = EF_TextColor_TextColorSecondary;
    _bottomLabel.textAlignment = NSTextAlignmentLeft;
    
    _lineView = [UIView new];
    _lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    
    NSArray *views = @[_leftImageView, _topLabel, _bottomLabel, _lineView];
    
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    CGFloat spaceToLeft = 20;
    
    _leftImageView.sd_layout
    .topSpaceToView(contentView, 20)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(16)
    .heightIs(20);
    
    _topLabel.sd_layout
    .topEqualToView(_leftImageView)
    .leftSpaceToView(_leftImageView, 10)
    .rightSpaceToView(contentView, spaceToLeft)
    //.widthIs(SCREEN_WIDTH/2-2*(spaceToLeft+10+16))
    .heightIs(20);
    
    _bottomLabel.sd_layout
    .topSpaceToView(_topLabel, 10)
    .leftEqualToView(_topLabel)
    .rightSpaceToView(contentView,spaceToLeft)
    //.widthIs(SCREEN_WIDTH/2-2*(spaceToLeft+10+16))
    .heightIs(15);
    
    _lineView.sd_layout
    .topSpaceToView(_bottomLabel, 10)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(0.5);
    
}

- (void)setModel:(Risks *)model {
    _model = model;
    _topLabel.text = _model.riskName;
    _bottomLabel.text = _model.otherName;
    
    //适配
    UIView *bottomView;
    bottomView = _lineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

@end
