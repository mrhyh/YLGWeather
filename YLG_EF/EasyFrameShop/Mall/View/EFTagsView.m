//
//  EFTagsView.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/26.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFTagsView.h"
#import "EFTagModel.h"
#import "EFTagButton.h"

static CGFloat const defaultEdgeMargin = 15.0f;
static CGFloat const defaultMargin = 10.0f;
static CGFloat const defaultRowMaxWidthRatio = 0.8f;
static CGFloat const defaultTitleLabelHeight = 20.0f;
static CGFloat const defaultTagButtonlHeight = 20.0f;

@interface EFTagsView()
//标签模型数组
@property (nonatomic, copy) NSArray *tagModelArray;
//标题
@property (nonatomic, copy) NSString *title;
//标签Label
@property (nonatomic, weak) UILabel *titleLabel;
//被选中的按钮
@property (nonatomic, strong) EFTagButton *selectButton;
@end
@implementation EFTagsView
#pragma mark ---life cycle
- (instancetype)initWithFrame:(CGRect)frame andTagModelArray:(NSArray<EFTagModel *> *)tagModelArray andTagsViewTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        _tagModelArray = [tagModelArray copy];
        _title = [title copy];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    titleLabel.sd_resetLayout.topEqualToView(self).leftSpaceToView(self,defaultMargin).rightEqualToView(self).heightIs(defaultTitleLabelHeight);
    self.titleLabel = titleLabel;
    
    __block UIView *lastView = nil;
    __block CGFloat tagButtonX = 0;
    __block CGFloat tagButtonY = 0;
    __block CGFloat rowMaxWidth = defaultEdgeMargin;
    //记录标签的行数
    __block NSInteger count = 0;
    
    [self.tagModelArray enumerateObjectsUsingBlock:^(NSString *tagModel, NSUInteger idx, BOOL * _Nonnull stop) {
        EFTagButton *tagButton = [EFTagButton buttonWithType:UIButtonTypeCustom];
        if (rowMaxWidth > self.width * defaultRowMaxWidthRatio) {
            rowMaxWidth = defaultEdgeMargin;
            count += 1;
        }
//        [tagButton setTitle:tagModel.title forState:UIControlStateNormal];
        [tagButton setTitle:tagModel forState:UIControlStateNormal];
        [tagButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        tagButton.tag = tagModel.tagId;
        tagButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [tagButton sizeToFit];
        [tagButton addTarget:self action:@selector(tagButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        tagButton.width += 2* defaultMargin;
        tagButton.height = defaultTagButtonlHeight;
        [self addSubview:tagButton];
        tagButtonX = rowMaxWidth;
        rowMaxWidth = rowMaxWidth + tagButton.width + defaultMargin;
        tagButtonY = defaultTitleLabelHeight + defaultMargin + (defaultMargin + defaultTagButtonlHeight) * count;
        tagButton.origin = CGPointMake(tagButtonX, tagButtonY);
        lastView = tagButton;
    }];
    
    
    [self setupAutoHeightWithBottomView:lastView bottomMargin:defaultMargin];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __block UIView *lastView = nil;
    __block CGFloat tagButtonX = 0;
    __block CGFloat tagButtonY = 0;
    __block CGFloat rowMaxWidth = defaultEdgeMargin;
    //记录标签的行数
    __block NSInteger count = 0;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([subView isKindOfClass:[EFTagButton class]]) {
            EFTagButton *tagButton = (EFTagButton *)subView;
            if (rowMaxWidth > self.width * defaultRowMaxWidthRatio) {
                rowMaxWidth = defaultEdgeMargin;
                count += 1;
            }
            tagButtonX = rowMaxWidth;
            rowMaxWidth = rowMaxWidth + tagButton.width + defaultMargin;
            tagButtonY = defaultTitleLabelHeight + defaultMargin + (defaultMargin + defaultTagButtonlHeight) * count;
            tagButton.origin = CGPointMake(tagButtonX, tagButtonY);
            lastView = tagButton;
        }

    }];
    
    [self setupAutoHeightWithBottomView:lastView bottomMargin:defaultMargin];
}

- (void)tagButtonDidClick:(EFTagButton *)tagButton{
    tagButton.selected = YES;
    self.selectButton.selected = NO;
    self.selectButton = tagButton;
    if ([self.delegate respondsToSelector:@selector(tagsViewDidClickTagButton:andTagButton:)]) {
        [self.delegate tagsViewDidClickTagButton:self andTagButton:tagButton];
    }
}
@end
