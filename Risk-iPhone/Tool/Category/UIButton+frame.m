//
//  UIButton+frame.m
//  buttonDemo
//
//  Created by ZQD on 14-11-25.
//  Copyright (c) 2014年 ZQD. All rights reserved.
//

#import "UIButton+frame.h"

@implementation UIButton (frame)

-(float)imageLeft{
    return self.imageView.frame.origin.x;
}

//UIControlContentHorizontalAlignmentLeft：UIEdgeInsetsMake(0, padding, 0, 0)     center：UIEdgeInsetsMake(0, padding, 0, -padding)  right：UIEdgeInsetsMake(0, 0, 0, padding)


-(void)setImageLeft:(float)imageLeft{
    if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentLeft) {
        //相对于初始位置的偏移,AlignmentLeft时image初始位置永远为0,0
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, imageLeft, 0, 0)];
        
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentCenter){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, -(self.frame.size.width-self.titleLabel.frame.size.width-self.imageView.frame.size.width)/2+imageLeft, 0, (self.frame.size.width-self.titleLabel.frame.size.width-self.imageView.frame.size.width)/2-imageLeft)];
        });
        
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentRight){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.frame.size.width-self.imageView.frame.size.width-self.titleLabel.frame.size.width-imageLeft)];
        });
    }
}

-(float)titleLeft{
    return self.titleLabel.frame.origin.x;
}
-(void)setTitleLeft:(float)titleLeft{
    
    if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentLeft) {
        
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width+titleLeft, 0, 0)];
        
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentCenter){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.frame.size.width-self.imageView.frame.size.width-self.titleLabel.frame.size.width)/2-self.imageView.frame.size.width+titleLeft, 0, (self.frame.size.width-self.imageView.frame.size.width-self.titleLabel.frame.size.width)/2+self.imageView.frame.size.width-titleLeft)];
        });
        
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentRight){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (self.frame.size.width-self.titleLabel.frame.size.width)-titleLeft)];
        });
    }

}


-(float)titleCenter{
    
    return self.frame.size.width/2;
}
-(void)setTitleCenter{
    
    if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentLeft) {
        
        //相对于初始位置的偏移,AlignmentLeft时title初始位置永远为image的右边位置(当title改变时马上执行此方法，titlelabel的frame还没修改，所以要延时处理)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, (self.frame.size.width-self.titleLabel.frame.size.width)/2-self.imageView.frame.size.width, 0, 0)];
        });
    
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentCenter){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, (self.imageView.frame.size.width)/2-self.imageView.frame.size.width, 0, -(self.imageView.frame.size.width)/2+self.imageView.frame.size.width)];
        });
        
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentRight){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(self.frame.size.width-self.titleLabel.frame.size.width)/2+self.frame.size.width-self.titleLabel.frame.size.width)];
        });
    }

}


-(void)setimageToTitleRight{
    NSInteger padingInteger = 2;  //图片和文字间距
    if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentLeft) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.frame.size.width, 0, 0)];
        });
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentCenter){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width-padingInteger, 0, self.imageView.frame.size.width+padingInteger)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.frame.size.width+padingInteger, 0, -self.titleLabel.frame.size.width-padingInteger)];
        });
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentRight){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.imageView.frame.size.width)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.frame.size.width)];
        });
    }
}


-(void)setImageAndTitleCenterImageTopWithpadding:(float)padding{
    
    if (!padding) {
        padding = 0;
    }
    
    if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentLeft) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setImageEdgeInsets:UIEdgeInsetsMake(-self.imageView.frame.size.height-padding, (self.frame.size.width-self.imageView.frame.size.width)/2, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(self.titleLabel.frame.size.height+padding, (self.frame.size.width-self.titleLabel.frame.size.width)/2-self.imageView.frame.size.width, 0, 0)];
        });
        
    }else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setImageEdgeInsets:UIEdgeInsetsMake(-self.imageView.frame.size.height-padding, self.titleLabel.frame.size.width/2, 0, -self.titleLabel.frame.size.width/2)];
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(self.titleLabel.frame.size.height+padding, -self.imageView.frame.size.width/2, 0, self.imageView.frame.size.width/2)];
        });
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentRight){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self setImageEdgeInsets:UIEdgeInsetsMake(-self.imageView.frame.size.height-padding, 0, 0, (self.frame.size.width-self.imageView.frame.size.width)/2-self.titleLabel.frame.size.width)];
            
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(self.titleLabel.frame.size.height+padding, 0, 0, (self.frame.size.width-self.titleLabel.frame.size.width)/2)];
        });
    }
}

-(void)setImageAndTitleCenterTitleTopWithpadding:(float)padding{
    
    
    if (!padding) {
        padding = 0;
    }
    
    if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentLeft) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setImageEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+padding, (self.frame.size.width-self.imageView.frame.size.width)/2, 0, 0)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-padding, (self.frame.size.width-self.titleLabel.frame.size.width)/2-self.imageView.frame.size.width, 0, 0)];
        });
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentCenter) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setImageEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+padding, self.titleLabel.frame.size.width/2, 0, -self.titleLabel.frame.size.width/2)];
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-padding, -self.imageView.frame.size.width/2, 0, self.imageView.frame.size.width/2)];
        });
    }else if (self.contentHorizontalAlignment==UIControlContentHorizontalAlignmentRight){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self setImageEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+padding, 0, 0, (self.frame.size.width-self.imageView.frame.size.width)/2-self.titleLabel.frame.size.width)];
            
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-self.titleLabel.frame.size.height-padding, 0, 0, (self.frame.size.width-self.titleLabel.frame.size.width)/2)];
        });
    }
}

- (UIEdgeInsets)touchAreaInsets
{
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}
/**
 *  @brief  设置按钮额外热区
 */
- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
