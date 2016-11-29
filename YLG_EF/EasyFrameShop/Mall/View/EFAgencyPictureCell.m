//
//  EFAgencyPictureCell.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFAgencyPictureCell.h"
#import <XHImageViewer.h>
#import "UIView+SDAutoLayout.h"
#import "EFHeader.h"
#import "UIImageView+WebCache.h"
#import "UIColor+UIColor_Hex.h"
#import "EFSkinThemeManager.h"

static CGFloat const cellMargin = 10.0f;

@interface EFAgencyPictureCell()
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation EFAgencyPictureCell
- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

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
    titleLabel.text  = @"医疗环境";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor =  EF_TextColor_TextColorSecondary;
    [titleView addSubview:titleLabel];
    titleLabel.sd_layout.centerYEqualToView(titleView).leftSpaceToView(titleView,cellMargin).autoHeightRatio(0).widthIs(100);
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = EF_TextColor_TextColorSecondary;
    countLabel.font = [UIFont systemFontOfSize:15];
    countLabel.textAlignment = NSTextAlignmentRight;
    [titleView addSubview:countLabel];
    self.countLabel = countLabel;
    countLabel.sd_layout.centerYEqualToView(titleView).rightSpaceToView(titleView,cellMargin).widthIs(100).heightIs(15);
    
    CGFloat scrollViewH = (SCREEN_WIDTH - 7 * cellMargin) / 4.0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.sd_layout.topSpaceToView(titleView,cellMargin * 2).leftSpaceToView(self.contentView,cellMargin).rightSpaceToView(self.contentView,cellMargin * 3).heightIs(scrollViewH);
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_arrow_right_1"]]];
    [self.contentView addSubview:arrowImageView];
    arrowImageView.sd_layout.centerYEqualToView(scrollView).rightSpaceToView(self.contentView,10).widthIs(10).heightIs(15);
}

- (void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    NSInteger count = imageUrls.count;
    CGFloat imageViewH = (SCREEN_WIDTH - 7 * cellMargin) / 4.0;
    CGFloat imageViewW = imageViewH;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    if (count > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"共%zd张",count];
        self.scrollView.contentSize = CGSizeMake(imageViewW + (imageViewW + cellMargin) * (count - 1), 0);
        for (NSInteger i = 0; i < count; i ++) {
            imageViewX = (cellMargin + imageViewW) * i;
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]]];
            imageView.backgroundColor = [UIColor magentaColor];
            imageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imageView];
            imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
            imageView.tag = i;
            [self.imageArray addObject:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [tap addTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
        }
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap{
    NSLog(@"%@",self.scrollView.subviews);
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    [imageViewer showWithImageViews:self.imageArray selectedView:(UIImageView *)tap.view];
}
@end
