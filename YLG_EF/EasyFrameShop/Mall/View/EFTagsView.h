//
//  EFTagsView.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/26.
//  Copyright © 2016年 MH. All rights reserved.
//  标签视图

#import <UIKit/UIKit.h>
#import "EFTagButton.h"

@class EFTagModel,
       EFTagsView;

@protocol EFTagsViewDelegate <NSObject>
@optional
- (void)tagsViewDidClickTagButton:(EFTagsView *)tagsView andTagButton:(EFTagButton *)tagButton;

@end
@interface EFTagsView : UIView
/**
 *  创建标签视图
 *
 *  @param frame          标签的初始尺寸
 *  @param tagsModelArray 标签模型数组
 *  @param title          标签视图的标题
 *
 *  @return 标签视图
 */
- (instancetype)initWithFrame:(CGRect)frame
             andTagModelArray:(NSArray <EFTagModel*> *)tagModelArray
             andTagsViewTitle:(NSString *)title;
@property (nonatomic, weak) id <EFTagsViewDelegate> delegate;
@end
