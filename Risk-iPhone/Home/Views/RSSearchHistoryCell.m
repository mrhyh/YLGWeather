//
//  RSSearchHistoryCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSSearchHistoryCell.h"

@implementation RSSearchHistoryCell {
    KYMHLabel * titleLB;
}

- (instancetype)initWithHistroy:(NSString *)_str {
    
    UIColor * textMainColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"histroyCell"]) {
        titleLB = [[KYMHLabel alloc]initWithTitle:_str BaseSize:CGRectMake(10, 15, 150, 20) LabelColor:[UIColor clearColor] LabelFont:middleFontSize LabelTitleColor:textMainColor TextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLB];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(10, 49.5, SCREEN_WIDTH-10, 0.5)];
        _line.backgroundColor = EF_TextColor_TextColorDisable;
        [self addSubview:_line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end
