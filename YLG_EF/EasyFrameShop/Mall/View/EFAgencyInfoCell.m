//
//  EFAgencyInfoCell.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFAgencyInfoCell.h"

@interface EFAgencyInfoCell()
@property (nonatomic, weak) UILabel *contentLabel;
@end
@implementation EFAgencyInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupView{
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = HEX_COLOR(@"#f6f6f6");
    [self.contentView addSubview:titleView];
    titleView.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView).heightIs(25);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text  = @"简介";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor =  EF_TextColor_TextColorSecondary;
    [titleView addSubview:titleLabel];
    titleLabel.sd_layout.centerYEqualToView(titleView).leftSpaceToView(titleView,10).autoHeightRatio(0).rightSpaceToView(titleView,20);
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = EF_TextColor_TextColorSecondary;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:contentLabel];
    contentLabel.sd_layout.topSpaceToView(titleView,15).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
    self.contentLabel = contentLabel;
}



- (void)setAgencyInfo:(NSString *)agencyInfo{
    _agencyInfo = agencyInfo;
    self.contentLabel.text = agencyInfo;
}
@end
