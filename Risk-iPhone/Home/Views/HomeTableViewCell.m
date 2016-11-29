//
//  HomeTableViewCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/8/17.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()

@property (nonatomic, strong)  KYMHLabel *titleLabel;
@property (nonatomic, strong)  KYMHLabel *statusLabel;
@property (nonatomic, strong)  KYMHLabel *dataLabel;
@property (nonatomic, strong)  KYMHImageView *leftImageView;

@end

@implementation HomeTableViewCell{
    
    CGFloat spaceToLeft;
    CGFloat imageH;
    CGFloat imageW;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    spaceToLeft = 15;
    imageW = 60;
    imageH = 60;
    
    
    _titleLabel = [KYMHLabel new];
    _titleLabel.textColor = EF_TextColor_TextColorPrimary;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = Font(middleFontSize);
    
    
    _leftImageView = [KYMHImageView new];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImageView.clipsToBounds = YES;
    
    _statusLabel = [KYMHLabel new];
    _statusLabel.textColor = EF_TextColor_TextColorSecondary;
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.font = Font(10);
    
    _dataLabel = [KYMHLabel new];
    _dataLabel.textColor = EF_TextColor_TextColorSecondary;
    _dataLabel.textAlignment = NSTextAlignmentRight;
    _dataLabel.font = Font(10);
    
    NSArray *views = @[_titleLabel, _statusLabel, _leftImageView,_dataLabel];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    CGFloat spaceToTop = MFCommonspaceToTop;
    
    _leftImageView.sd_layout
    .topSpaceToView (contentView, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(imageW)
    .heightIs(imageH);
    
    _leftImageView.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,spaceToTop)
    .bottomSpaceToView(contentView,spaceToTop)
    .widthIs(MFCommonImageW)
    .heightIs(MFCommonImageH);
    
    NSLog(@"MFCommonImageW=%fMFCommonImageH=%f",MFCommonImageW,MFCommonImageH);
    
    _titleLabel.sd_layout
    .topEqualToView(_leftImageView)
    .leftSpaceToView(_leftImageView, 10)
    .rightSpaceToView(contentView, spaceToLeft)
    .maxHeightIs(50)
    .autoHeightRatio(0);
    
    
    CGFloat dateLabelW = 60;
    if (SCREEN_HEIGHT >= 736){
        dateLabelW = 80;
    }
    _dataLabel.sd_layout
    .bottomEqualToView(_leftImageView)
    .rightSpaceToView(contentView,spaceToLeft)
    .widthIs(dateLabelW)
    .heightIs(20);
    
    _statusLabel.sd_layout
    .bottomEqualToView(_leftImageView)
    .leftSpaceToView(_leftImageView,spaceToLeft)
    .rightSpaceToView(_dataLabel,2)
    .heightIs(20);
}

- (void) setModel:(Filesitems *)model {
    
    _model = model;
    _titleLabel.text = model.title;
    
    NSString *theFileSizeString;
    if ([UIUtil isNoEmptyStr:model.smallFileSize ]) {
        theFileSizeString = [RSMethod fileSizeString:model.smallFileSize];
    }else {
        theFileSizeString = [RSMethod fileSize:model.fileSize];
    }

    NSString *readString = [RSMethod readCount:model.contentSocail.readCount];
    NSString *timeString = [RSMethod returnDateStringWithTimestamp:model.uploadDate];
    _statusLabel.text = [NSString stringWithFormat:@"%@  %@", readString,theFileSizeString ];
    _dataLabel.text = timeString;
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImage.url] placeholderImage:Img(@"tupian")];
}

@end
