//
//  UIImageCategory.h
//  Exam
//
//  Created by  on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import "EFHeader.h"

//是否是高清屏幕
#define isiPhoneRetina [[UIScreen mainScreen] currentMode].size.width >= 640

//是否是高清屏幕
#define isiPhone5Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
//是否是高清iPad屏幕
#define isPadRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(2048,1536), [[UIScreen mainScreen] currentMode].size) : NO)

//是否是高清iPad屏幕
#define isPadRetinaLand ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536,2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define isRetina (isiPhone5Retina || isiPhoneRetina || isPadRetina || isPadRetinaLand || IS_IPHONE6 || IS_IPHONE6PS)

@interface UIImage (UIImageFitSizeCategory) 


//根据当前图片的大小，和需要显示的图片大小，得到同比例缩放后的大小
- (CGSize) sizeWithFitInSize : (CGSize)aSize;

//根据需要显示的图片大小，得到同比例缩放后的图片对象，支持高清缩放，即是高清屏幕时缩放的图片均为显示图片的两倍
- (UIImage *) imageWithFitInSize : (CGSize)aSize;

//根据需要显示的图片大小，得到同比例缩放后的图片对象
- (UIImage *) imageWithOutRetinaFitInSize : (CGSize)aSize;

//根据尺寸的大小，让图片全部填充满
- (UIImage *)imageWithFillInSize : (CGSize)aSize;

//裁剪图片尺寸只获取中间显示部分
- (UIImage *)imageCorrectInSize : (CGSize)aSize;

-(UIImage*)scaleToSize:(CGSize)size;
//压缩图片
- (CGSize)sizeCorrectInSize : (CGSize)aSize;

//获取图形库文件支持方向正常显示
-(UIImage *)rotateImage;

- (UIImage *)imageWithBlurLevel:(CGFloat)blur;

+ (UIImage*) imageWithColor: (UIColor *) color;

- (UIImage*) imageWithMaskImage:(UIImage *)image;

- (UIImage*) getGrayImage;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)cutImage:(UIImage*)image Size : (CGSize)aSize;

//裁剪图片尺寸只获取中间显示部分
- (UIImage *)imageCuteInSize : (CGSize)aSize WithY : (float)_y;

@end    

@implementation UIImage (UIImageFitSizeCategory)

- (UIImage*) imageWithMaskImage:(UIImage *)_maskimage{
    
    CGImageRef maskRef = _maskimage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([self CGImage], mask);
    return [UIImage imageWithCGImage:masked];  
    
}

//加模糊效果，image是图片，blur是模糊度
- (UIImage *)imageWithBlurLevel:(CGFloat)blur
{
    
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = self.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    //CGColorSpaceRelease(colorSpace);   //多余的释放
    CGImageRelease(imageRef);
    
    return returnImage;
}
 
//获取图形库文件支持方向正常显示
-(UIImage *)rotateImage
{
    CGImageRef imgRef = self.CGImage;
    UIImageOrientation orient = self.imageOrientation;
    UIImageOrientation newOrient = UIImageOrientationUp;
    switch (orient) {
        case 3://竖拍 home键在下
            newOrient = UIImageOrientationRight;
            break;
        case 2://倒拍 home键在上
            newOrient = UIImageOrientationLeft;
            break;
        case 0://左拍 home键在右
            newOrient = UIImageOrientationUp;
            break;
        case 1://右拍 home键在左
            newOrient = UIImageOrientationDown;
            break;
        default:
            newOrient = UIImageOrientationRight;
            break;
    }
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGFloat ratio = 0;
    if ((width > 1024) || (height > 1024)) {
        if (width >= height) {
            ratio = 1024/width;
        }
        else {
            ratio = 1024/height;
        }
        width *= ratio;
        height *= ratio;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    switch(newOrient)
    {
        case UIImageOrientationUp: 
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationDown: 
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft: 
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight: 
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (newOrient == UIImageOrientationRight || newOrient == UIImageOrientationLeft) 
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else 
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//裁剪图片尺寸只获取中间显示部分
- (UIImage *)imageCorrectInSize : (CGSize)aSize{

    if (aSize.width >= self.size.width && aSize.height >= self.size.height) {
        return self;
    }
    CGSize size ;
    size = [self sizeCorrectInSize:aSize];
      
	float dWidth = (self.size.width - size.width)/2.0;
    float dHeight = (self.size.height - size.height)/2.0;
    
    CGRect rect1 =  CGRectMake(dWidth, dHeight, size.width, size.height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect1);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    NSLog(@"1---绘制过后长度是%f  绘制过后宽度是%f",smallImage.size.width,smallImage.size.height);
    
    UIGraphicsBeginImageContext(aSize);
    // 绘制改变大小的图片
    [smallImage drawInRect:CGRectMake(0, 0, aSize.width,aSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    UIImage* newimage = scaledImage;
    NSLog(@"2---绘制过后长度是%f  绘制过后宽度是%f",newimage.size.width,newimage.size.height);
//    newimage = [newimage rotateImage];
	return newimage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    NSLog(@"绘制过后长度是%f  绘制过后宽度是%f",scaledImage.size.width,scaledImage.size.height);
    // 返回新的改变大小后的图片
    return scaledImage;
}

//压缩图片
- (CGSize)sizeCorrectInSize : (CGSize)aSize{
    CGFloat scale;
    CGSize thisSize = self.size;
	CGSize newsize = thisSize;
    if ((thisSize.width/aSize.width)>=(thisSize.height/aSize.height)) {
        scale = (float)newsize.height/aSize.height;
        newsize.width = aSize.width*scale;
    }
    else {
        scale = (float)newsize.width/aSize.width;
        newsize.height =aSize.height * scale;
    }
    
    return newsize;
}


/***
 *  根据当前图片的大小，和需要显示的图片大小，得到同比例缩放后的大小
 **/

- (CGSize) sizeWithFitInSize : (CGSize)aSize{
    
    CGFloat scale;
    CGSize thisSize = self.size;
	CGSize newsize = thisSize;
	
    if ((thisSize.width/aSize.width)>=(thisSize.height/aSize.height)) {
        scale = (float)aSize.width/newsize.width;
        newsize.width *=scale;
        newsize.height *=scale;
    }
    else {
        scale = (float)aSize.height/newsize.height;
        
        newsize.width *=scale;
        newsize.height *=scale;
    }
	return newsize;
}


- (UIImage *)imageWithFillInSize : (CGSize)aSize{
    CGSize size ;
        size.width = aSize.width;
        size.height = aSize.height;

    UIGraphicsBeginImageContext(aSize);

	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[self drawInRect:rect];
	
	UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newing;
}


/***
 *  根据需要显示的图片大小，得到同比例缩放后的图片对象，支持高清缩放，即是高清屏幕时缩放的图片均为显示图片的两倍
**/
- (UIImage *) imageWithFitInSize : (CGSize)aSize
{
    if (aSize.width >= self.size.width && aSize.height >= self.size.height) {
        return self;
    }
    
    if (isRetina) {
        aSize = CGSizeMake(aSize.width * 2,aSize.height * 2);
    }
    CGSize size = [self sizeWithFitInSize:aSize];
	UIGraphicsBeginImageContext(aSize);
    
	float dWidth = (aSize.width - size.width)/2.0;
	float dHeight = (aSize.height - size.height)/2.0;
	
	CGRect rect = CGRectMake(dWidth, dHeight, size.width, size.height);
	[self drawInRect:rect];
	
	UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newing;
}

- (UIImage *)cutImage:(UIImage*)image Size : (CGSize)aSize
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    CGFloat scale = image.size.width / aSize.width;
    newSize.width = aSize.width*scale;
    newSize.height = aSize.height*scale;
    if (image.size.width > image.size.height) {
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width), 0, aSize.width*2, aSize.height*2));
    }else{
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height), aSize.width*2, aSize.height*2));
    }
    return [UIImage imageWithCGImage:imageRef];
}

//根据需要显示的图片大小，得到同比例缩放后的图片对象
- (UIImage *) imageWithOutRetinaFitInSize : (CGSize)aSize{
    if (aSize.width >= self.size.width && aSize.height >= self.size.height) {
        return self;
    }
    CGSize size = [self sizeWithFitInSize:aSize];
	UIGraphicsBeginImageContext(size);
	
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[self drawInRect:rect];
	
	UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	//NSLog(@"----image-size---%f,%f",newing.size.width,newing.size.height);
	return newing;
}

+ (UIImage *) imageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage*)getGrayImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


//裁剪图片尺寸只获取中间显示部分
- (UIImage *)imageCuteInSize : (CGSize)aSize WithY : (float)_y{
    CGSize sSize = self.size;
    float wrate = sSize.width / aSize.width;
    float hrate = sSize.height / aSize.height;
    float rate = hrate < wrate?hrate:wrate;
    CGSize fSize = CGSizeMake(aSize.width * rate, aSize.height * rate);
    
    CGRect rect  =  CGRectMake((sSize.width-fSize.width)/2, (sSize.height-fSize.height)/2, fSize.width-0.1, fSize.height);
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage * newimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    NSLog(@"-------------size : %@",NSStringFromCGSize(newimage.size));
    return newimage;
}


//裁剪图片尺寸只获取中间显示部分
- (UIImage *)imageCuteInSize2 : (CGSize)aSize WithY : (float)_y{
    CGSize sSize = self.size;
    float wrate = aSize.width / sSize.width;
    float height = aSize.height / wrate;
    
    CGRect rect;
    if (height > sSize.height) {
        rect =  CGRectMake(0, 0, sSize.width-1, sSize.height);
    }
    else{
        if (_y == -1) {
            _y = sSize.height/2;
        }
        float starty = _y - height/2;
        if (starty < 0) {
            starty = 0;
        }
        else if(starty > (sSize.height-height)){
            starty = sSize.height-height;
        }
        rect =  CGRectMake(0, starty, sSize.width, height);
    }
    NSLog(@"-------------size : %@",NSStringFromCGSize(self.size));
    NSLog(@"-------------rect : %@",NSStringFromCGRect(rect));
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage * newimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    NSLog(@"-------------size : %@",NSStringFromCGSize(newimage.size));
    return newimage;
}


@end
