//
//  RSEPLeftCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSEPLeftCell.h"


@interface RSEPLeftCell ( )

@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHImageView *headImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation RSEPLeftCell {
    
    CGFloat sumLabelFontSize;
    CGFloat spaceToLeft;
    CGFloat selectButtonH;
    CGFloat cellH;
    
    UIColor *labelSelectedColor;
    UIColor *labelUnSelectedColor;
    UIColor *cellSelectedColor;
    UIColor *cellUnSelectedColor;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    spaceToLeft = 20;
    cellH = 50;
    labelUnSelectedColor = RGBColor(208, 209, 208);
    labelSelectedColor = RGBColor(221, 80, 84);
    cellSelectedColor = RGBColor(208, 208, 208);
    cellUnSelectedColor = [UIColor whiteColor];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    _headImageView = [KYMHImageView new];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.clipsToBounds = YES;
    
    _nameLabel = [KYMHLabel new];
    _nameLabel.text = @"";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = Font(middleFontSize);
    _nameLabel.textColor = EF_TextColor_TextColorPrimary;

    NSArray *views = @[_headImageView, _nameLabel, _lineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _lineView.sd_layout
    .topEqualToView(contentView)
    .leftSpaceToView(contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(1);
    
    CGFloat imageH = 40;
    _headImageView.sd_layout
    .leftSpaceToView (contentView, spaceToLeft)
    .centerYEqualToView(contentView)
    .widthIs(imageH)
    .heightIs(imageH);
    _headImageView.layer.cornerRadius = imageH/2;
    
    _nameLabel.sd_layout
    .leftSpaceToView (_headImageView, 20 )
    .rightSpaceToView(contentView, 10)
    .centerYEqualToView(_headImageView)
    .heightIs(20);
}

- (void ) setModel:(HuanXinUserModel *)model {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.head.url] placeholderImage:Img(@"ic_defaultavatar")];
    _nameLabel.text = model.nickname;
}



@end
