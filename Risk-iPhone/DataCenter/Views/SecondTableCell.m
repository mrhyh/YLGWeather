//
//  SecondTableCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/26.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "SecondTableCell.h"

@interface SecondTableCell ()

@property (nonatomic,strong) KYMHImageView * imageView1;
@property (nonatomic,strong) KYMHLabel * titleLB;
@property (nonatomic,strong) KYMHLabel * numberOfReadLB;
@property (nonatomic,strong) KYMHLabel * sizeLB;
@property (nonatomic,strong) KYMHImageView * rightImageView;
@property (nonatomic,strong) UIView * line;

@end

@implementation SecondTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    _imageView1 = [[KYMHImageView alloc]init];
    _imageView1.backgroundColor = [UIColor grayColor];
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    _imageView1.clipsToBounds = YES;
    
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
    _rightImageView.hidden = YES; //需求更改，不用了
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackHint];
    
    NSArray * views = @[_imageView1,_titleLB,_numberOfReadLB,_sizeLB,_rightImageView,_line];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    CGFloat spaceToTop = MFCommonspaceToTop;
    
    _imageView1.sd_layout
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
    .leftSpaceToView(_imageView1,10)
    .bottomEqualToView(_imageView1)
    .heightIs(10);
    [_numberOfReadLB setSingleLineAutoResizeWithMaxWidth:150];
    
    _sizeLB.sd_layout
    .leftSpaceToView(_imageView1,10)
    .rightSpaceToView(contentView, 10)
    .topEqualToView(_numberOfReadLB)
    .heightIs(10);
    
    _titleLB.sd_layout
    .topEqualToView(_imageView1)
    .leftSpaceToView(_imageView1,10)
    .rightSpaceToView(_rightImageView,5)
    .autoHeightRatio(0);
    [_titleLB setMaxNumberOfLinesToShow:2];
    
    _line.sd_layout
    .leftSpaceToView(contentView,0)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
}


- (void ) setModel:(FilesitemsModel *)model {
    _model = model;
    
    NSString *imageUrl;
    if (nil != _model.smallMainImage && [UIUtil isNoEmptyStr:_model.smallMainImage.url]) {
        imageUrl = _model.smallMainImage.url;
    }else {
        imageUrl = _model.mainImage.url;
    }
    
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Img(@"tupian")];
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
        _sizeLB.text = [NSString stringWithFormat:@"%@  %@                %@", readString,theFileSizeString, timeString ];
    }else {
        _sizeLB.text = [NSString stringWithFormat:@"%@  %@        %@", readString,theFileSizeString, timeString ];
    }
}

@end
