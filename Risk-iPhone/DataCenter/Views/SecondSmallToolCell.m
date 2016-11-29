//
//  SecondSmallToolCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "SecondSmallToolCell.h"

@interface SecondSmallToolCell ()
@property (nonatomic,strong) KYMHLabel * nameLB;
@property (nonatomic,strong) KYMHImageView * rightImageView;
@property (nonatomic,strong) UIView * line;

@end

@implementation SecondSmallToolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _nameLB = [[KYMHLabel alloc]init];
    _nameLB.backgroundColor = [UIColor clearColor];
    _nameLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _nameLB.font = Font(smallFontSize);
    _nameLB.textAlignment = NSTextAlignmentLeft;
    
    _rightImageView = [[KYMHImageView alloc]init];
    _rightImageView.backgroundColor = [UIColor clearColor];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackHint];
    
    NSArray * views = @[_nameLB,_rightImageView,_line];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    _nameLB.sd_layout
    .leftSpaceToView(contentView,10)
    .centerYEqualToView(contentView)
    .widthIs(150)
    .heightIs(30);
    
    _rightImageView.sd_layout
    .rightSpaceToView(contentView,10)
    .centerYEqualToView(contentView)
    .heightIs(16)
    .widthIs(10);
    
    _line.sd_layout
    .leftSpaceToView(contentView,0)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
}

- (void)setModel:(FilesitemsModel *)model {
    
    [_rightImageView setImage:Img(@"ic_arrow_right_1")];
    
    _model = model;
    _nameLB.text = _model.title;
}

@end
