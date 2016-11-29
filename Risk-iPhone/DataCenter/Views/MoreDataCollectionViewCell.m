//
//  MoreDataCollectionViewCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "MoreDataCollectionViewCell.h"

@interface MoreDataCollectionViewCell ()

@property (nonatomic,strong) KYMHImageView * imageView;
@property (nonatomic,strong) KYMHLabel * titleLB;
@property (nonatomic,strong) KYMHLabel * numberOfReadLB;
@property (nonatomic,strong) KYMHLabel * sizeLB;
@property (nonatomic,strong) KYMHImageView * rightImageView;
@property (nonatomic,strong) UIView * line;
@property (nonatomic,strong) UIView * vLine;

@end

@implementation MoreDataCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
        //[self set];
    }
    return self;
}

- (void)setUp {
    
    _imageView = [[KYMHImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    _titleLB = [[KYMHLabel alloc]init];
    _titleLB.backgroundColor = [UIColor clearColor];
    _titleLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _titleLB.font = Font(smallFontSize);
    _titleLB.textAlignment = NSTextAlignmentLeft;
    
    _numberOfReadLB = [[KYMHLabel alloc]init];
    _numberOfReadLB.backgroundColor = [UIColor clearColor];
    _numberOfReadLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackHint];
    _numberOfReadLB.font = Font(10);
    _numberOfReadLB.textAlignment = NSTextAlignmentLeft;
    
    _sizeLB = [[KYMHLabel alloc]init];
    _sizeLB.backgroundColor = [UIColor clearColor];
    _sizeLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackHint];
    _sizeLB.font = Font(10);
    _sizeLB.textAlignment = NSTextAlignmentLeft;
    
    _rightImageView = [[KYMHImageView alloc]init];
    _rightImageView.backgroundColor = [UIColor clearColor];
    _rightImageView.hidden = YES;
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    _vLine = [[UIView alloc]init];
    _vLine.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    NSArray * views = @[_imageView,_titleLB,_numberOfReadLB,_sizeLB,_rightImageView,_line,_vLine];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    CGFloat spaceToTop = MFCommonspaceToTop;
    
    _imageView.sd_layout
    .leftSpaceToView(contentView,20)
    .topSpaceToView(contentView,spaceToTop)
    .bottomSpaceToView(contentView,spaceToTop)
    .widthIs(MFCommonImageW)
    .heightIs(MFCommonImageH);
    
    _rightImageView.sd_layout
    .rightSpaceToView(contentView,10)
    .centerYEqualToView(contentView)
    .heightIs(16)
    .widthIs(10);
    
    _numberOfReadLB.sd_layout
    .leftSpaceToView(_imageView,10)
    .bottomEqualToView(_imageView)
    .heightIs(10);
    [_numberOfReadLB setSingleLineAutoResizeWithMaxWidth:150];
    
    _sizeLB.sd_layout
    .leftSpaceToView(_imageView,10)
    .rightSpaceToView(contentView, 10)
    .topEqualToView(_numberOfReadLB)
    .heightIs(10);
    
    _titleLB.sd_layout
    .topEqualToView(_imageView)
    .leftSpaceToView(_imageView,10)
    .rightSpaceToView(_rightImageView,5)
    .autoHeightRatio(0);
    [_titleLB setMaxNumberOfLinesToShow:2];
    
    _line.sd_layout
    .leftSpaceToView(contentView,0)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
    
    _vLine.sd_layout
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .widthIs(0.5)
    .heightRatioToView(contentView,1.0);
}


- (void ) setModel:(FilesitemsModel *)model {
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.mainImage.url] placeholderImage:Img(@"tupian")];
    [_rightImageView setImage:Img(@"ic_arrow_right_1")];
    _titleLB.text = model.title;

    NSString *theFileSizeString;
    if ([UIUtil isNoEmptyStr:model.smallFileSize ]) {
        theFileSizeString = [RSMethod fileSizeString:model.smallFileSize];
    }else {
        theFileSizeString = [RSMethod fileSize:model.fileSize];
    }
    
    
    NSString *readString = [RSMethod readCount:model.contentSocail.readCount];
    NSString *timeString = [RSMethod returnDateStringWithTimestamp:model.uploadDate];
    
    if (SCREEN_HEIGHT >= 667) {
        _sizeLB.text = [NSString stringWithFormat:@"%@  %@               %@", readString,theFileSizeString, timeString ];
    }else {
        _sizeLB.text = [NSString stringWithFormat:@"%@  %@ %@", readString,theFileSizeString, timeString ];
    }
}

- (void)setHealthModel:(Content *)healthModel {
    
    NSString *imageUrl;
    
    if (nil != healthModel.smallMainImage && [UIUtil isNoEmptyStr:healthModel.smallMainImage.url]) {
        imageUrl = healthModel.smallMainImage.url;
    }else {
         imageUrl = healthModel.mainImage.url;
    }
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Img(@"tupian")];
    [_rightImageView setImage:Img(@"ic_arrow_right_1")];
    _titleLB.text = healthModel.title;
    
    NSString *theFileSizeString;
    if ([UIUtil isNoEmptyStr:healthModel.smallFileSize ]) {
        theFileSizeString = [RSMethod fileSizeString:healthModel.smallFileSize];
    }else {
        theFileSizeString = [RSMethod fileSizeString:healthModel.fileSize];
    }
    
    NSString *readString = [RSMethod readCount:healthModel.contentSocail.readCount];
    NSString *timeString = [RSMethod returnDateStringWithTimestamp:healthModel.uploadDate];
    
    if (SCREEN_HEIGHT >= 667) {
        _sizeLB.text = [NSString stringWithFormat:@"%@  %@               %@", readString,theFileSizeString, timeString ];
    }else {
        _sizeLB.text = [NSString stringWithFormat:@"%@  %@         %@", readString,theFileSizeString, timeString ];
    }
}

@end
