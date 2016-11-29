//
//  IGCarousel.h
//  IGCustom
//
//  Created by iGalactus on 15/12/30.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCarouselObject.h"

typedef enum {
    //横向滚动(默认选项)
    IGCarouselAnimationStyleScroll = 0,
    //淡出淡入
    IGCarouselAnimationStyleFade = 1,
}IGCarouselAnimationStyle;

@interface EFCarousel : UIView

//显示方式
@property (nonatomic) IGCarouselAnimationStyle animationStyle;
//数据源,子集为IGCarouselObject,接受子集为NSString的URL,并自动转为CarouselObject
@property (nonatomic,strong) NSArray *carouselList;
//显示的序号数,默认为0,如果序号大于内容数组,则为最大值
@property (nonatomic) NSInteger currentIndex;
//是否自动滚动 默认为是
@property (nonatomic) BOOL carouselAutoScroll;
//自动滚动间隔 默认为3秒
@property (nonatomic) NSTimeInterval autoScrollTimeInterval;
//指示器
@property (nonatomic,strong) UIPageControl *pageControl;
//标题
@property (nonatomic,strong) UILabel *contentLabel;


//刷新视图
-(void)reloadCarousel;
//点击的回调
@property (nonatomic,copy) void (^ iGCarouselSelectedBlock)(NSInteger index , EFCarouselObject *carouselObject);

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com