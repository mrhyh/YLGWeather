//
//  GoodsCommentCell.m
//  hujinrong
//
//  Created by HqLee on 16/5/17.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFGoodsCommentCell.h"
#import "StarView.h"

@interface EFGoodsCommentCell()

@end
const CGFloat GCLabelFontSize = 15;
CGFloat maxGCLabelHeight = 0;
@implementation EFGoodsCommentCell{
    UILabel * _nameLabel;
    UILabel * _timeLabel;
    UILabel * _ContentLabel;
    UIView   *_line;
    StarView * star;
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
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:13];
//    _nameLabel.text = @"uesrname";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = EF_TextColor_TextColorSecondary;
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:15];
//    _timeLabel.text = @"2016-05-05";
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = EF_TextColor_TextColorSecondary;
    
    
    _ContentLabel = [UILabel new];
    _ContentLabel.font = [UIFont systemFontOfSize:GCLabelFontSize];
    _ContentLabel.textColor = EF_TextColor_TextColorPrimary;
//    _ContentLabel.text = @"Oral-B 欧乐 D20.525.4X 4000 3D自能电动牙刷";
    if (maxGCLabelHeight == 0) {
        maxGCLabelHeight = _ContentLabel.font.lineHeight * 3;
    }
   
    _line = [UIView new];
    _line.backgroundColor = EF_TextColor_TextColorDisable;
    
    
    star = [[StarView alloc] init];
//    star.starLevel = 3.5;
    star.isTouchaAailable = NO;
    star.starScale = 0.5;

    
    NSArray *views = @[_nameLabel, _timeLabel, _ContentLabel, star, _line];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _nameLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:100*SCREEN_W_RATE];
    
    _timeLabel.sd_layout
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .heightIs(20);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120*SCREEN_W_RATE];
    
    star.sd_layout
    .leftSpaceToView(_nameLabel, margin)
    .topSpaceToView(contentView, 15)
    .widthIs(70);
    
    
    _ContentLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_nameLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _line.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_ContentLabel, margin)
    .heightIs(0.5)
    .widthIs(SCREEN_WIDTH-10);
}

- (void)setCommentModel:(ProductCommentModel *)commentModel{
    _commentModel = commentModel;
    _nameLabel.text = commentModel.evaluater.nickname;
    _timeLabel.text = [UIUtil getDateFromDate:[NSString stringWithFormat:@"%zd",commentModel.evaluateTime] isHms:NO];
    star.starLevel = commentModel.score;
    _ContentLabel.text = commentModel.content;
    
}
@end
