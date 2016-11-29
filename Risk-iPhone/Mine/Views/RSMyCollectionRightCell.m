//
//  RSMyCollectionRightCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/18.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMyCollectionRightCell.h"

@interface RSMyCollectionRightCell ()

@property (nonatomic, strong) KYMHImageView *cellImageView;

@property (nonatomic,strong) KYMHLabel * titleLB;
@property (nonatomic,strong) KYMHLabel * numberOfReadLB;
@property (nonatomic,strong) KYMHLabel * sizeLB;
@property (nonatomic,strong) UIView * lineView;

@end

@implementation RSMyCollectionRightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void ) setUp {
    
    _cellImageView = [[KYMHImageView alloc]init];
    _cellImageView.contentMode = UIViewContentModeScaleAspectFill;
    _cellImageView.clipsToBounds = YES;
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:Img(@"")];
    
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
    
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    
    NSArray * views = @[_cellImageView,_titleLB,_numberOfReadLB,_sizeLB,_lineView];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    
    CGFloat spaceToTop = MFCommonspaceToTop;
    
    _cellImageView.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,spaceToTop)
    .bottomSpaceToView(contentView,spaceToTop)
    .widthIs(MFCommonImageW)
    .heightIs(MFCommonImageH);
    
    NSLog(@"MFCommonImageW=%fMFCommonImageH=%f",MFCommonImageW,MFCommonImageH);

    _titleLB.sd_layout
    .topEqualToView(_cellImageView)
    .leftSpaceToView(_cellImageView,10)
    .rightSpaceToView(contentView,5)
    .autoHeightRatio(0);
    [_titleLB setMaxNumberOfLinesToShow:2];
    
    _numberOfReadLB.sd_layout
    .leftSpaceToView(_cellImageView,10)
    .bottomEqualToView(_cellImageView)
    .heightIs(15);
    [_numberOfReadLB setSingleLineAutoResizeWithMaxWidth:150];
    
    _sizeLB.sd_layout
    .leftSpaceToView(_cellImageView,10)
    .rightSpaceToView(contentView, 10)
    .topEqualToView(_numberOfReadLB)
    .heightIs(15);
    
    _lineView.sd_layout
    .leftSpaceToView(contentView,0)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
}

- (void ) setModel:(Riskfiles *)model {
    _model = model;
    

    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:_model.mainImage.url] placeholderImage:Img(@"")];
    _titleLB.text = _model.title;

    NSString *theFileSizeString;
    if ([UIUtil isNoEmptyStr:model.smallFileSize ]) {
        theFileSizeString = [RSMethod fileSizeString:model.smallFileSize];
    }else {
        theFileSizeString = [RSMethod fileSize:model.fileSize];
    }
    
    
    NSString *readString = [RSMethod readCount:model.contentSocail.readCount];
    NSString *timeString = [RSMethod returnDateStringWithTimestamp:model.uploadDate];

    
    if (SCREEN_HEIGHT >= 667) {
        _sizeLB.text= [NSString stringWithFormat:@"%@  %@                %@", readString,theFileSizeString, timeString ];
    }else {
        _sizeLB.text= [NSString stringWithFormat:@"%@  %@        %@", readString,theFileSizeString, timeString ];
    }
    
    //cell高度适配
    UIView *bottomView;
    bottomView = _lineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}
@end
