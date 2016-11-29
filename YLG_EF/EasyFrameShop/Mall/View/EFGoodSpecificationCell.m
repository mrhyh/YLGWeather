//
//  EFGoodSpecificationCell.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//  商品规格cell

#import "EFGoodSpecificationCell.h"
#import "EFSkinThemeManager.h"
#import "UIView+SDAutoLayout.h"

@interface EFGoodSpecificationCell()
@property (nonatomic, weak) UILabel *selectResultLabel;
@end

@implementation EFGoodSpecificationCell
#pragma mark --- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = EF_TextColor_TextColorSecondary;
    titleLabel.text = @"已选:";
    titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:titleLabel];
    
    UILabel *selectResultLabel = [[UILabel alloc] init];
    selectResultLabel.textColor = EF_TextColor_TextColorPrimary;
    selectResultLabel.font = [UIFont systemFontOfSize:13];
    selectResultLabel.numberOfLines = 1;
    [self.contentView addSubview:selectResultLabel];
    self.selectResultLabel = selectResultLabel;
    
    //auto layout
    titleLabel.sd_layout.leftSpaceToView(self.contentView,10).centerYEqualToView(self.contentView).heightIs(15).widthIs(30);
    selectResultLabel.sd_layout.leftSpaceToView(titleLabel,5).topEqualToView(titleLabel).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
}

#pragma mark --- setter
- (void)setSelectResult:(NSString *)selectResult{
    _selectResult = [selectResult copy];
    self.selectResultLabel.text = selectResult;
}
@end
