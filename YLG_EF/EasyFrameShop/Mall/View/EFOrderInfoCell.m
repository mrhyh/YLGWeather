//
//  EFOrderInfoCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderInfoCell.h"

@interface EFOrderInfoCell ()



@end


@implementation EFOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//1. 创建控件
- (void)setup{
    CGFloat spaceToLeft = 10;
    
    _leftLabel = [KYMHLabel new];
    _leftLabel.font = Font(14);
    _leftLabel.textColor = EF_TextColor_TextColorSecondary;
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    
    _rightLabel = [KYMHLabel new];
    _rightLabel.font = Font(14);
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    _rightLabel.textColor = EF_TextColor_TextColorPrimary;
    
    _lineView = [UIView new];
    _lineView.backgroundColor = RGBColor(246, 246, 246);
    
    //布局
    NSArray *views = @[_leftLabel, _rightLabel, _lineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _leftLabel.sd_layout
    .leftSpaceToView (contentView, spaceToLeft)
    .topSpaceToView (contentView, spaceToLeft)
    .widthIs(70)
    .heightIs(20);
    
    _rightLabel.sd_layout
    .leftSpaceToView (_leftLabel, 20)
    .topSpaceToView (contentView, spaceToLeft)
    .heightIs(20);
    [_rightLabel setSingleLineAutoResizeWithMaxWidth:(SCREEN_WIDTH-2*spaceToLeft-70)];
    
    _lineView.sd_layout
    .leftSpaceToView (contentView, spaceToLeft)
    .topSpaceToView (_leftLabel, spaceToLeft)
    .widthIs (SCREEN_WIDTH-2*spaceToLeft)
    .heightIs(2);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
