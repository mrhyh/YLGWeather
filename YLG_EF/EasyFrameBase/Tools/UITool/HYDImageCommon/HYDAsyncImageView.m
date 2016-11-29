//
//  HYDAsyncImageView.m
//  Exam
//
//  Created by  on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDAsyncImageView.h"
#import "HYDFileManager.h"
#import "HYDImageCategory.h"


@implementation HYDAsyncImageView

//@synthesize imageName,imageRequest;
@synthesize delegate = _delegate;
@synthesize useImage;

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame AndUrl:nil];
}

- (id)initWithFrame:(CGRect)frame Image : (UIImage *)_image{
    self = [self initWithFrame:frame AndUrl:nil];
    if (self) {
        [self performSelector:@selector(AsyncImageLoadFinish:) withObject:_image afterDelay:0.2];
    }
    return self;
}

//通过图片的frame和异步加载的图片地址来初始化图片视图，加载时显示默认的加载框
- (id)initWithFrame:(CGRect)frame AndUrl : (NSString *)_url{
    return [self initWithFrame:frame AndUrl:_url ShowProgress:NO];
}

//通过图片的frame和异步加载的图片地址来初始化图片视图，加载时显示默认的加载框
- (id)initWithFrame:(CGRect)frame AndUrl : (NSString *)_url ShowProgress : (BOOL)_isProgress{
    return [self initWithFrame:frame AndUrl:_url ShowProgress:_isProgress Delegate:nil];
}

- (id)initWithFrame:(CGRect)frame AndUrl : (NSString *)_url ShowProgress : (BOOL)_isProgress Delegate : (id)_delegatee{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = _delegatee;
        isProgress = _isProgress;
        //indicatorView = [[HYDActivityIndicatorView alloc] init];
        //初始化加载进度条
        if (_url != nil && ![_url isEqualToString:@""]) {
            [self performSelector:@selector(AsyncLoadImageWithUrlStr:) withObject:_url afterDelay:0.2];
        }
    }
    return self;
}

-(NSString *)getImageNameByUrl : (NSString *)_url{
    NSArray *arr = [_url componentsSeparatedByString:@"://"];
    if ([arr count] >= 2) {
        NSString *name = [arr objectAtIndex:1];
        name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        return name;
    }
    return @"";
}


-(void)AsyncLoadImageWithUrlStr : (NSString *)_urlStr{
    //NSLog(@"----------------开始加载图片，是否显示进度条 : %d",isProgress);
    for (UIView *sview in self.subviews) {
        [sview removeFromSuperview];
    }
    self.imageName = [self getImageNameByUrl:_urlStr];
    UIImage *image = [HYDFileManager getTempImageByName:imageName];
    if (image) {
        [self AsyncImageLoadFinish:image];
    }
    else
    {
        [self AsyncImageLoadFinish:[self getDefaultImage]];
        NSURL *url = [NSURL URLWithString:_urlStr];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self AsyncLoadImageWithUrl:url];
        });
    }
}

- (UIImage *)getDefaultImage{
    return [UIImage imageNamed:@"productitem.png"];
}

-(void)AsyncLoadImageWithUrl : (NSURL *)_url{
    [self stopLoadImage];
//    self.imageRequest = [[ASIHTTPRequest alloc] initWithURL:_url];
//    imageRequest.delegate = self;
//    imageRequest.timeOutSeconds = 120;
//    [imageRequest setDownloadProgressDelegate:self];
//   EFPageRequestst startAsynchronous];
}


-(void)AsyncImageLoadFinish : (UIImage *)_image{
    for (UIView *sview in self.subviews) {
        [sview removeFromSuperview];
    }
    self.useImage = _image;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
    [self stopLoadImage];
    [_delegate AsyncImageLoadFinish:_image Sender:self];
}

-(void)setImage : (UIImage *)_image{
    [self AsyncImageLoadFinish:_image];
}

- (void)stopLoadImage{
    [self performSelector:@selector(hiddenActivity)];
//    if (imageRequest) {
//        [imageRequest clearDelegatesAndCancel];
//        self.imageRequest = nil;
//    }
}

- (UIImage *)getImage{
    return self.useImage;
}

#pragma ASIHTTPREQUEST
//- (void)requestFinished:(ASIHTTPRequest *)_request
//{
//    [self performSelector:@selector(hiddenActivity)];
//    NSData *responseData = [_request responseData];
//    [HYDFileManager saveTempImageData:responseData ImageName:imageName];
//    UIImage *image = [[UIImage alloc] initWithData:responseData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self AsyncImageLoadFinish:image];
//    });
//}

//- (void)requestFailed:(ASIHTTPRequest *)_request
//{
//    NSLog(@"-----request failed-----error : %@",_request.error);
//    [self performSelector:@selector(hiddenActivity)];
//    [_delegate AsyncImageLoadFaild:self];
//}

#pragma ASIProgressDelegate
- (void)setProgress:(float)newProgress{
    
}


- (void)hiddenActivity{

}

- (void)dealloc
{
//    [imageRequest clearDelegatesAndCancel];
//    self.imageRequest = nil;
    self.useImage = nil;
}


@end
