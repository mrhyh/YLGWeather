//
//  IGCarousel.m
//  IGCustom
//
//  Created by iGalactus on 15/12/30.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "EFCarousel.h"
@interface EFCarousel()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *carouselInnerList;
@property (nonatomic,strong) NSMutableArray *releasePool;

@property (nonatomic) NSInteger subItemsCount;//子集数目
@property (nonatomic) BOOL isScrollToRight;
@property (nonatomic) CGFloat tempScrollX;
@property (nonatomic,strong) NSTimer *autoTimer;

@end

@implementation EFCarousel

-(instancetype)init
{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initParams];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initParams];
    }
    return self;
}

-(void)initParams
{
    self.currentIndex = 0;
    self.subItemsCount = 0;
    self.carouselAutoScroll = YES;
    self.autoScrollTimeInterval = 3.0f;
    
    self.backgroundColor = [UIColor blackColor];
    
    [self initUI];
}

-(void)initUI
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = BCWhiteColor(0, 0.4);
    _bottomView.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = 10;
    [self addSubview:_bottomView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    [self addSubview:_pageControl];
    
    [self addSubview:self.contentLabel];
}

-(void)reloadCarousel
{
    [self resize];
}

-(void)resize
{
    if (CGRectIsEmpty(self.frame)) {
        return;
    }
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.pageControl.frame = CGRectMake(0, self.scrollView.frame.size.height - 30, self.scrollView.frame.size.width, 30);
    self.bottomView.frame = CGRectMake(SCREEN_WIDTH/2-self.carouselInnerList.count*10*SCREEN_W_RATE, self.scrollView.frame.size.height - 25, self.carouselInnerList.count*20*SCREEN_W_RATE, 20);
    if (self.currentIndex > self.carouselInnerList.count - 1) {
        self.currentIndex = self.carouselInnerList.count - 1;
    }
    
    self.pageControl.numberOfPages = self.carouselInnerList.count;
    self.pageControl.currentPage = self.currentIndex;
    
    [self allocateUI];
    [self carouselAutoScrollAction];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (self.autoTimer) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
    if (_carouselInnerList) return;
    [self carouselInnerList];
    if (!CGRectIsEmpty(self.frame)) {
        [self resize];return;
    }
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resize];
    });
}

-(void)carouselAutoScrollAction
{
    [self.autoTimer invalidate];
    self.autoTimer = nil;
    if (self.carouselAutoScroll) {
        self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(autoTimerSchedule) userInfo:nil repeats:YES];
    }
}

//定时器滚动反应方法
-(void)autoTimerSchedule
{
    switch (self.animationStyle) {
        case IGCarouselAnimationStyleScroll:{
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
        }
            break;
        case IGCarouselAnimationStyleFade:{
            UIImageView *carouselSubItem = [self.releasePool objectAtIndex:0];
            EFCarouselObject *obj = self.carouselInnerList[self.currentIndex];
            [self scrollEndAction];
            
            [UIView animateWithDuration:0.2f animations:^{
                carouselSubItem.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3f delay:0.0f options:2<<16 animations:^{
                    [carouselSubItem sd_setImageWithURL:[NSURL URLWithString:obj.imageURL] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_loadingimg"]] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (image) {
                            carouselSubItem.contentMode =  UIViewContentModeScaleAspectFill;
                            carouselSubItem.clipsToBounds = YES;
                            carouselSubItem.image = image;
                        }
                    }];
                    carouselSubItem.alpha = 1.0f;
                } completion:nil];
            }];
        }
        default:
            break;
    }
}

//将视图添加到scrollView上
-(void)allocateUI
{
    for (__strong UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
            subView = nil;
        }
    }
    
    if (self.carouselInnerList.count == 0) {
        return;
    }
    
    if ((self.subItemsCount == 1 && self.animationStyle == IGCarouselAnimationStyleScroll) || self.animationStyle == IGCarouselAnimationStyleFade) {
        self.scrollView.scrollEnabled = NO;
        
        if (self.animationStyle == IGCarouselAnimationStyleFade) {
            if (self.releasePool.count == 1) {
                return;
            }
        }
        
        UIImageView *releaseSubItem = [self releasePoolSubItem];
        releaseSubItem.frame = self.scrollView.bounds;
        [self.scrollView addSubview:releaseSubItem];
        [self.releasePool addObject:releaseSubItem];
        
        if (self.animationStyle == IGCarouselAnimationStyleFade) { //加载视图
            UIImageView *carouselSubItem = [self.releasePool objectAtIndex:0];
            EFCarouselObject *obj = self.carouselInnerList[_currentIndex];
            [carouselSubItem sd_setImageWithURL:[NSURL URLWithString:obj.imageURL] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_loadingimg"]]  options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    carouselSubItem.contentMode =  UIViewContentModeScaleAspectFill;
                    carouselSubItem.clipsToBounds = YES;
                    carouselSubItem.image = image;
                }
            }];

            self.currentIndex ++;
        }
        return;
    }
    
    for (int i = 0;i < 3;i ++) {
        UIImageView *releaseSubItem = [self releasePoolSubItem];
        releaseSubItem.frame = CGRectMake(self.scrollView.frame.size.width * i,
                                          0,
                                          self.scrollView.frame.size.width,
                                          self.scrollView.frame.size.height);
        [self.scrollView addSubview:releaseSubItem];
        [self.releasePool addObject:releaseSubItem];
    }
    [self reloadScrollData];
}

-(void)subItemAction
{
    if (self.iGCarouselSelectedBlock) {
        self.iGCarouselSelectedBlock(self.currentIndex,self.carouselInnerList[self.currentIndex]);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollX = scrollView.contentOffset.x;
    self.isScrollToRight = (scrollX - self.tempScrollX) > 0;
    self.tempScrollX = scrollX;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollEndAction];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.autoTimer) {
        [self scrollEndAction];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoTimer) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self carouselAutoScrollAction];
}

//滚动结束后的操作
-(void)scrollEndAction
{
    switch (self.animationStyle) {
        case IGCarouselAnimationStyleScroll:{
            if (self.subItemsCount == 2) {
                return;
            }
            
            if (self.isScrollToRight) {
                self.currentIndex ++;
            }
            else{
                self.currentIndex --;
            }
            
            self.pageControl.currentPage = _currentIndex;
            [self reloadScrollData];
        }
            break;
        case IGCarouselAnimationStyleFade:{
            self.pageControl.currentPage = _currentIndex;
            self.currentIndex ++;
        }
            
        default:
            break;
    }
}

//重新更新视图数据
-(void)reloadScrollData
{
    
    int temp = 0;
    for (UIImageView *subItem in self.releasePool) {
        EFCarouselObject *carouselObject;
        switch (temp) {
            case 0:{
                carouselObject = self.carouselInnerList[[self formerIndex]];
            }
                break;
            case 1:{
                carouselObject = self.carouselInnerList[self.currentIndex];
            }
                break;
            case 2:{
                carouselObject = self.carouselInnerList[[self nextIndex]];
            }
                break;
                
            default:
                break;
        }
        [subItem sd_setImageWithURL:[NSURL URLWithString:carouselObject.imageURL] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_loadingimg"]]  options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                subItem.contentMode =  UIViewContentModeScaleAspectFill;
                subItem.clipsToBounds = YES;
                subItem.image = image;
            }
        }];

        temp ++;
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    [self reloadContentLabelData];
}

//前一个
-(NSInteger)formerIndex
{
    if (_currentIndex == 0) {return self.carouselInnerList.count - 1;}
    return _currentIndex - 1;
}

//后一个
-(NSInteger)nextIndex
{
    if (_currentIndex == self.carouselInnerList.count - 1) {return 0;}
    return _currentIndex + 1;
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    if (currentIndex > self.carouselList.count - 1) {
        _currentIndex = 0;
    }
    
    if (currentIndex < 0) {
        _currentIndex = self.carouselList.count - 1;
    }
}

//刷新内容视图的尺寸
-(void)reloadContentLabelData
{
    if (_carouselInnerList.count < 2) {
        return;
    }
//    IGCarouselObject *carouselObject = self.carouselInnerList[self.currentIndex];
//    self.contentLabel.text = carouselObject.content;
//    self.contentLabel.frame = [self contentLabelFrame];
}

//计算内容Label的高度
//-(CGRect)contentLabelFrame
//{
//    CGFloat contentH = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width, MAXFLOAT)
//                                                            options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
//                                                         attributes:@{NSFontAttributeName : self.contentLabel.font}
//                                                            context:nil].size.height;
//    if (self.contentLabel.text && self.contentLabel.text.length == 0) {
//        contentH = 0;
//    }
//    return CGRectMake(0,
//                      0,
//                      self.scrollView.frame.size.width,
//                      contentH);
//}

-(NSMutableArray *)releasePool
{
    if (!_releasePool) {
        _releasePool = [[NSMutableArray alloc] init];
    }
    return _releasePool;
}

-(UIImageView *)releasePoolSubItem
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subItemAction)];
    [imageView addGestureRecognizer:tapGesture];
    return imageView;
}

-(NSMutableArray *)carouselInnerList
{
    if (!_carouselInnerList || _carouselInnerList.count == 0) {
        _carouselInnerList = [[NSMutableArray alloc] init];
        
        for (NSObject *object in self.carouselList) {
            if ([object isKindOfClass:[NSString class]]) {
                EFCarouselObject *carouselObj = [[EFCarouselObject alloc] init];
                carouselObj.imageURL = (NSString *)object;
                [_carouselInnerList addObject:carouselObj];
            }
            if ([object isKindOfClass:[EFCarouselObject class]]) {
                [_carouselInnerList addObject:object];
            }
        }
        self.subItemsCount = _carouselInnerList.count;
    }
    return _carouselInnerList;
}

//-(UILabel *)contentLabel
//{
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.textColor = [UIColor whiteColor];
//        _contentLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
//        _contentLabel.font = [UIFont systemFontOfSize:15];
//        _contentLabel.numberOfLines = 0;
//        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    }
//    return _contentLabel;
//}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com