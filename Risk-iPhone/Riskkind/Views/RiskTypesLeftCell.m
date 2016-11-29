//
//  RiskTypesLeftCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/1.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypesLeftCell.h"

@interface RiskTypesLeftCell ( )

@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) KYMHImageView *indicatorImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation RiskTypesLeftCell {
    
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
    cellH = 44;
    labelUnSelectedColor = RGBColor(208, 209, 208);
    labelSelectedColor = RGBColor(221, 80, 84);
    cellSelectedColor = RGBColor(208, 208, 208);
    cellUnSelectedColor = [UIColor whiteColor];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    _label = [UILabel new];
    _label.text = @"09";
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor =labelUnSelectedColor;
    _label.layer.masksToBounds = YES;
    
    _nameLabel = [KYMHLabel new];
    _nameLabel.text = @"测试";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = Font(middleFontSize);
    _nameLabel.textColor = EF_TextColor_TextColorPrimary;
    
    _indicatorImageView = [KYMHImageView new];
    _indicatorImageView.image = Img(@"img_cellSelect");
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    NSArray *views = @[_label, _nameLabel, _indicatorImageView, _lineView,line];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _lineView.sd_layout
    .topEqualToView(contentView)
    .leftSpaceToView(contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(1);
    
    _label.sd_layout
    .leftSpaceToView (contentView, spaceToLeft)
    .centerYEqualToView(contentView)
    .widthIs(20)
    .heightIs(20);
    _label.layer.cornerRadius = 10;
    
    _nameLabel.sd_layout
    .leftSpaceToView (_label, 20 )
    .centerYEqualToView(_label)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-50];
    
    _indicatorImageView.sd_layout
    .centerYEqualToView(contentView)
    .rightSpaceToView(contentView, 0)
    .widthIs(15)
    .heightIs(15);
    
    line.sd_layout
    .leftSpaceToView(contentView,10)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .heightIs(0.5);
    line.hidden = YES;  //暂时不用，用系统的线
}

- (void)setLabelBGColor:(UIColor *)labelBGColor {
    
    _labelBGColor = labelBGColor;
    _nameLabel.backgroundColor = labelBGColor;
}

- (void)setRiskTypeModel:(Children *)riskTypeModel {
    
    if(riskTypeModel.integer > 0 && riskTypeModel.integer < 10) {
        _label.text = [NSString stringWithFormat:@"0%d", riskTypeModel.integer];
    }else {
        _label.text = [NSString stringWithFormat:@"%d", riskTypeModel.integer];
    }
    
    _nameLabel.text = riskTypeModel.name;
    
    if(riskTypeModel.isSelect ) {
        _label.backgroundColor = labelSelectedColor;
        _lineView.hidden = NO;
        self.contentView.backgroundColor = cellSelectedColor;
        _indicatorImageView.hidden = NO;
    } else {
        _label.backgroundColor = labelUnSelectedColor;
        _lineView.hidden = YES;
        self.contentView.backgroundColor = cellUnSelectedColor;
        _indicatorImageView.hidden = YES;
    }
}

- (void ) setModel:(ChildrensModel *)model {
    
    if(model.integer > 0 && model.integer < 10) {
        _label.text = [NSString stringWithFormat:@"0%ld", (long)model.integer];
    }else {
        _label.text = [NSString stringWithFormat:@"%ld", (long)model.integer];
    }
    
    _nameLabel.text = model.name;
    _nameLabel.font = Font(MFRiskTypeNoFDAFontSize);
    
    if(model.isSelect ) {
        _label.backgroundColor = labelSelectedColor;
        _lineView.hidden = NO;
        self.contentView.backgroundColor = cellSelectedColor;
        _indicatorImageView.hidden = NO;
    } else {
        _label.backgroundColor = labelUnSelectedColor;
        _lineView.hidden = YES;
        self.contentView.backgroundColor = cellUnSelectedColor;
        _indicatorImageView.hidden = YES;
    }
}

@end
