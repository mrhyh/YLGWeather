//
//  StarView.m
//  star
//
//  Created by KingYon on 15/4/17.
//  Copyright (c) 2015年 KingYon. All rights reserved.
//

#import "StarView.h"

#define StarViewWidth 182
#define StarViewHeight 30
#define StarWith 30
#define StarSpace 38

@interface StarView(){
    UIView *highlightStarView;
    UIView *nomalStarView;
}

@end

@implementation StarView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

#warning TODO 暂时保留老的接口,这是新接口
- (instancetype)initViewWithFrame:(CGRect)frame starSpace:(CGFloat)starSpace
                                                                    starW:(CGFloat) starW
{
    
    self = [super initWithFrame:frame];
    if (self){
        self.starViewH = frame.size.height;
        self.starViewW = frame.size.width;
        self.starW = starW;
        self.starSpace = starSpace;
        
        if(self.starViewH == 0){
            self.starViewH = StarViewHeight;
        }
        
        if(self.starViewW == 0){
            self.starViewW = StarViewWidth;
        }
        if(self.starW == 0){
            self.starW = StarWith;
        }
        if(self.starSpace == 0){
            self.starScale = StarSpace;
        }
        
        nomalStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.starViewW, self.starViewH)];
        [self addSubview:nomalStarView];
        
        highlightStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.starViewW, self.starViewH)];
        highlightStarView.clipsToBounds = YES;
        [self addSubview:highlightStarView];
        
        UIImage *himage = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_big"]];
        UIImage *nimage = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_default_big"]];
        
        for (int i = 0 ; i < 5; i ++) {
            UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.starSpace, 0, self.starW, self.starW)];
            im.image = nimage;
            [nomalStarView addSubview:im];
            
            im = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.starSpace, 0, self.starW, self.starW)];
            im.image = himage;
            [highlightStarView addSubview:im];
        }
        _starScale = 1;
        self.isTouchaAailable = YES;
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
    }
    
    return self;
}

- (void)initView{

    nomalStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, StarViewWidth, StarViewHeight)];
    [self addSubview:nomalStarView];
    
    highlightStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, StarViewWidth, StarViewHeight)];
    [self addSubview:highlightStarView];
    highlightStarView.clipsToBounds = YES;
    
    UIImage *himage = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_big"]];
    UIImage *nimage = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/rate_star_default_big"]];
    
    for (int i = 0 ; i < 5; i ++) {
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(i * 38, 0, 30, 30)];
        im.image = nimage;
        [nomalStarView addSubview:im];
        
        im = [[UIImageView alloc] initWithFrame:CGRectMake(i * 38, 0, 30, 30)];
        im.image = himage;
        [highlightStarView addSubview:im];
    }
    _starScale = 1;
    self.isTouchaAailable = YES;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleRecognizer];
}

- (void)refreshSubviews : (UIView *)parentView Scale : (float)_scale{
    for (UIView *sv in [parentView subviews]) {
        sv.frame = CGRectMake(sv.frame.origin.x * _scale, sv.frame.origin.y * _scale, sv.frame.size.width * _scale, sv.frame.size.height * _scale);
        [self refreshSubviews:sv Scale:_scale];
    }
}
//点击
- (void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    if (!self.isTouchaAailable) {
        return;
    }
    CGPoint point = [recognizer locationInView:self];
    [self touchWithPoint:point];
}

- (void)setFrame:(CGRect)frame{
    if (frame.size.width == 0) {
        return;
    }
    self.starScale = frame.size.width / StarViewWidth;
    float height = StarViewHeight * self.starScale;
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,height)];
}

- (void)setStarScale:(float)starScale{
    float scale = starScale / _starScale;
    _starScale = starScale;
    [self refreshSubviews:self Scale:scale];
    float height = StarViewHeight * self.starScale;
    [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * scale, height)];
}

- (void)setStarLevel:(float)starLevel{
    if (starLevel > 5) {
        starLevel = 5;
    }
    if (starLevel < 0) {
        starLevel = 0;
    }
    _starLevel = starLevel;
    float space = ((int)starLevel) * StarSpace;
    float width1 = StarWith * (((int)(starLevel * 100)) % 100) / 100;
    
    float width = (space + width1) * self.starScale;
    highlightStarView.frame = CGRectMake(0, 0, width, highlightStarView.frame.size.height);
}

- (void)touchWithPoint : (CGPoint)_point{
    float pontx = _point.x / self.starScale;
    int level1 = (int)pontx / StarSpace;
    float level2 = (pontx - level1 * StarSpace) / StarWith;
    if (level2 > 0.1) {
        level1 += 1;
    }
    [self setStarLevel:level1];
}

//触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.isTouchaAailable) {
        return;
    }
    CGPoint p = [[touches anyObject] locationInView:self];
    [self touchWithPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.isTouchaAailable) {
        return;
    }
    CGPoint p = [[touches anyObject] locationInView:self];
    [self touchWithPoint:p];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.isTouchaAailable) {
        return;
    }
    CGPoint p = [[touches anyObject] locationInView:self];
    [self touchWithPoint:p];
}



@end
