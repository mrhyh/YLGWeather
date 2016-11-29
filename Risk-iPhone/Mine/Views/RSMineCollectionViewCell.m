//
//  RSMineCollectionViewCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMineCollectionViewCell.h"

@interface RSMineCollectionViewCell ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * versionLB;
@property (nonatomic,strong) UILabel * textLB;
@property (nonatomic,strong) UIView  * Hline;
@property (nonatomic,strong) UIView  * Vline;

@end

@implementation RSMineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _imageView = [[UIImageView alloc]init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    _versionLB = [[UILabel alloc]init];
    _versionLB.textAlignment = NSTextAlignmentCenter;
    _textLB.backgroundColor = [UIColor clearColor];
    _textLB.textColor = EF_MainColor;
    _textLB.font = Font(15);
    
    _textLB = [[UILabel alloc]init];
    _textLB.textAlignment = NSTextAlignmentCenter;
    _textLB.backgroundColor = [UIColor clearColor];
    _textLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _textLB.font = Font(11);
    
    _Hline = [[UIView alloc]init];
    _Hline.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    _Vline = [[UIView alloc]init];
    _Vline.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    UIView * contentView = self.contentView;
    NSArray * views = @[_imageView,_versionLB,_textLB,];
    [contentView sd_addSubviews:views];
    
    CGFloat imageViewWH = 40;  //6p+的尺寸
    

    if (SCREEN_HEIGHT <=568) {
        imageViewWH = 30;
    }
    
    _imageView.sd_layout
    .topSpaceToView(contentView,10)
    .centerXEqualToView(contentView)
    .widthIs(imageViewWH)
    .heightIs(imageViewWH);
    
    _versionLB.sd_layout
    .topSpaceToView(contentView,10)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(imageViewWH);
    
    _textLB.sd_layout
    .topSpaceToView(_imageView,5)
    .centerXEqualToView(contentView)
    .heightIs(20)
    .widthIs(contentView.frame.size.width);
}

- (void)setIndex:(int)index {
    NSArray * imageArr = @[@"passwords",@"date",@"collection",@"xiaoshou",@"edator",@"advertising",@"record",@"team",@"review",@"classification",@"opinion",@"update", @"--"];
    NSArray * titleArr = @[@"修改密码",@"使用有效期",@"我的收藏",@"销售记录",@"专家点评",@"广告服务",@"大事记",@"专家团队",@"提交记录",@"关于我们",@"意见反馈",@"更新记录", @"当前版本"];
    
    if (index != 12) {
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:imageArr[index]];
    }else {
        _versionLB.text = APP_VERSION;
    }
    
    
    
    _textLB.text = titleArr[index];
    
}

@end
