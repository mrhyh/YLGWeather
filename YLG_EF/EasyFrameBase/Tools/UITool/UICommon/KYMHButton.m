//
//  KYMHButton.m
//  NewTest
//
//  Created by MH on 16/2/1.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import "KYMHButton.h"
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
@implementation KYMHButton{
    CGFloat buttonFont;
}

- (instancetype)initWithbarButtonItem:(id)view Title:(NSString *)_title BaseSize:(CGRect)_baseSize ButtonColor:(UIColor*)_buttonColor ButtonFont:(CGFloat)_buttonFont ButtonTitleColor:(UIColor*)_buttonTitleColor Block:(KYMHButtonTouchBlock)action
{
    self = [super initWithFrame:_baseSize];
    if (self) {
        _block = action;
        buttonFont = _buttonFont;
        if (!_buttonColor) {
            _buttonColor = [UIColor clearColor];
        }
        if (!_buttonTitleColor) {
            _buttonTitleColor = [UIColor clearColor];
        }
        self.clipsToBounds = YES;
        self.backgroundColor = _buttonColor;
        [self setTitle:_title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:(_buttonFont)];
        [self setTitleColor:_buttonTitleColor forState:UIControlStateNormal];
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)touchAction:(id)sender{
    if (_block) {
        _block(self);
    }
    

}

- (void)ButtonImage:(UIImage *)_image{
    [self setImage:_image forState:UIControlStateNormal];
}

- (void)BackgroundImage:(UIImage *)_backgroundImage{
    [self setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
}

- (void)RectSize:(CGFloat)_rectSize SideWidth:(CGFloat)_sideWidth SideColor:(UIColor*)_sideColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = _rectSize;
    self.layer.borderColor = _sideColor.CGColor;
    self.layer.borderWidth = _sideWidth;
}


- (void)FontWeight:(CGFloat)_fontWeight{
    self.titleLabel.font = [UIFont systemFontOfSize:buttonFont weight:_fontWeight];
    if (CurrentSystemVersion < 8.2&&_fontWeight==UIFontWeightBold) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:(buttonFont)];
    }
}

- (void)IconFont:(NSString*)_iconFont{
    self.titleLabel.font = [UIFont fontWithName:_iconFont size:buttonFont];
}

- (void)verticalCenterImageAndTitle:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing/2), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing/2), 0.0, 0.0, - titleSize.width);
}

- (void)verticalCenterImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self verticalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImage:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, imageSize.width + spacing/2);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + spacing/2, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImage
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterTitleAndImage:DEFAULT_SPACING];
}


- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
{
    // get the size of the elements here for readability
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

- (void)horizontalCenterImageAndTitle;
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing
{
    // get the size of the elements here for readability
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0, 0.0);
}

- (void)horizontalCenterTitleAndImageLeft
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterTitleAndImageLeft:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImageRight
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterTitleAndImageRight:DEFAULT_SPACING];
}



- (void)setButtonType:(BOOL)buttonType
{

    self.flashButtonType = buttonType;
}

- (void)didTap:(UITapGestureRecognizer *)tapGestureHandler
{
    if (_block) {
        _block(self);
    }
    if (!self.flashButtonType) {
        return;
    } else {
        CGPoint tapLocation = [tapGestureHandler locationInView:self];
        CAShapeLayer *circleShape = nil;
        CGFloat scale = 1.0f;
        
        CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
        
        
        CGFloat biggerEdge = width > height ? width : height, smallerEdge = width > height ? height : width;
        CGFloat radius = smallerEdge / 2 > 20 ? 20 : smallerEdge / 2;
        
        scale = biggerEdge / radius + 0.5;
        circleShape = [self createCircleShapeWithPosition:CGPointMake(tapLocation.x - radius, tapLocation.y - radius)
                                                 pathRect:CGRectMake(0, 0, radius * 2, radius * 2)
                                                   radius:radius];
        
        
        [self.layer addSublayer:circleShape];
        [circleShape addAnimation:[self createFlashAnimationWithScale:scale duration:1.0f] forKey:nil];
    }
}

- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    
    circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    circleShape.fillColor = self.flashColor ? self.flashColor.CGColor : [UIColor whiteColor].CGColor;
    
    
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}


@end
