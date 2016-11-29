//
//  EFShopCartHeadView.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFShopCartHeadView.h"

@interface EFShopCartHeadView ( ) {
    
    EFShopCartHeadViewSelectedBlock shopCartHeadViewSelected;
}

@property (nonatomic, assign)  BOOL isButtonSelect;

@end

@implementation EFShopCartHeadView {
    CGFloat segmentH;
    CGFloat spaceToLeft;
    CGFloat sectionViewH;
    CGFloat sectionImageH;
    CGFloat sectionFontSize;

}

- (void)EFShopCartHeadViewSelectedWithBlock:(EFShopCartHeadViewSelectedBlock)block {
   // shopCartHeadViewSelected = block;
}

- (instancetype)initWithFrame:(CGRect)frame Name:(NSString *)name  SelectBlock:(EFShopCartHeadViewSelectedBlock)block {
    
    self = [super initWithFrame:frame];

    if(self ) {
        segmentH = frame.size.height;
        spaceToLeft = 10;
        sectionViewH = 30;
        sectionImageH = 17;
        sectionFontSize = 13;
        
        shopCartHeadViewSelected = block;
        
        UIView *headView = [[UIView alloc] initWithFrame:frame];
        headView.backgroundColor = RGBColor(248, 249, 248);
        [self addSubview:headView];
        
        _button = [KYMHButton new]; //
        [_button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_select"]] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _nameLabel = [KYMHLabel new];
        _nameLabel.textColor = EF_TextColor_TextColorPrimary;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = Font(sectionFontSize);
        
        _indicatorImageView = [KYMHImageView new];
        _indicatorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_arrow_right_1"]];
        
        [headView addSubview:_button];
        [headView addSubview:_nameLabel];
        [headView addSubview:_indicatorImageView];

        //更新数据
        _nameLabel.text = name;
        
        //布局
        CGFloat spaceToTop = (sectionViewH-sectionImageH)/2;
        _button.sd_layout
        .leftSpaceToView(headView, spaceToLeft)
        .topSpaceToView(headView, spaceToTop)
        .widthIs(sectionImageH)
        .heightIs(sectionImageH);
        
        
        _nameLabel.sd_layout
        .leftSpaceToView(_button, spaceToLeft)
        .topSpaceToView(headView, spaceToTop)
        .heightIs(sectionImageH);
        [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _indicatorImageView.sd_layout
        .leftSpaceToView(_nameLabel, spaceToLeft)
        .centerYEqualToView(_nameLabel)
        .widthIs(sectionImageH/2-5)
        .heightIs(sectionImageH/2);
    }
    
    return self;
}


- (void)buttonClickAction:(UIButton *)button {
    _button.selected = !_button.selected;
    _isButtonSelect = !_isButtonSelect;
    
    if(shopCartHeadViewSelected ) {
        shopCartHeadViewSelected(_button.selected);
    }
}
@end
