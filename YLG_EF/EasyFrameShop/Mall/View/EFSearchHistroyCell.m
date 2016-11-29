//
//  SearchHistroyCell.m
//  hujinrong
//
//  Created by Cherie Jeong on 16/5/3.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFSearchHistroyCell.h"

@implementation EFSearchHistroyCell {
    KYMHLabel * titleLB;
}

- (instancetype)initWithHistroy:(NSString *)_str {
    NSNumber * normal = [EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeNormal];//17
    NSNumber * middle = [EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeMiddle];//15
    NSNumber * small = [EFSkinThemeManager getFontSizeWithKey:SkinThemeKey_FontSizeSmall];//13
    
    UIColor * textMainColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    UIColor * textSecondColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"histroyCell"]) {
        titleLB = [[KYMHLabel alloc]initWithTitle:_str BaseSize:CGRectMake(10, 15, 150, 20) LabelColor:[UIColor clearColor] LabelFont:[middle floatValue] LabelTitleColor:textMainColor TextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLB];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-10, 0.5)];
        _line.backgroundColor = EF_TextColor_TextColorDisable;
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
