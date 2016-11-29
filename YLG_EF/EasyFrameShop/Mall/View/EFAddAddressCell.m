//
//  EFAddAddressCell.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/17.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFAddAddressCell.h"

@implementation EFAddAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"添加新地址";
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    [titleLabel setSingleLineAutoResizeWithMaxWidth:120];
    titleLabel.sd_layout.centerYEqualToView(self.contentView).centerXEqualToView(self.contentView).autoHeightRatio(0);
    
    UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_add"]]];
    [self.contentView addSubview:addImageView];
    addImageView.sd_layout.centerYEqualToView(titleLabel).rightSpaceToView(titleLabel,5).widthIs(30).heightIs(30);
}
@end
