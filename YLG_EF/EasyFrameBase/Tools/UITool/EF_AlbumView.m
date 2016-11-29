//
//  QF_AlbumView.m
//  QuickFlip
//
//  Created by 李传政 on 15-5-14.
//  Copyright (c) 2015年 KingYon LLC. All rights reserved.
//

#import "EF_AlbumView.h"
#import "XHZoomingImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "EFMyAutoAlertView.h"

@interface EF_AlbumView ()<UIScrollViewDelegate>
{
    UIScrollView    * scroll;
    UILabel * indexLb;
    int       count;
    int       index;
    CGRect    startFrame;
    NSMutableArray  * imageArr;
    NSMutableArray  * frameArr;
    NSMutableArray  * imgArr;


}

@end

@implementation EF_AlbumView

- (instancetype)initWithArr:(NSArray *)arr andFrame:(CGRect)frame andIndex:(int)_index
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        startFrame = frame;
        
        imageArr = [NSMutableArray array];
        frameArr =[NSMutableArray array];
        imgArr = [NSMutableArray array];
        
        [[UIApplication sharedApplication]setStatusBarHidden:YES];

        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:scroll];
        scroll.backgroundColor = [UIColor blackColor];
        scroll.pagingEnabled = YES;
        scroll.delegate = self;
        scroll.alpha = 0;
        
        indexLb = [[UILabel alloc]initWithFrame:CGRectMake(20*SCREEN_W_RATE, SCREEN_HEIGHT-40, 60*SCREEN_W_RATE, 40)];
        indexLb.textColor = [UIColor whiteColor];
        [self addSubview:indexLb];
        indexLb.textAlignment = NSTextAlignmentLeft;
        
        
        
        UIButton * m_sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        m_sureBtn.frame = CGRectMake(SCREEN_WIDTH-50*SCREEN_W_RATE,SCREEN_HEIGHT-40, 30, 30);
        [m_sureBtn setImage:[UIImage imageNamed:@"ic_menu_save.png"] forState:UIControlStateNormal];
        [m_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [m_sureBtn addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_sureBtn];
        
        
        
        if (arr.count > 0) {
            index = _index;
            [scroll setContentSize:CGSizeMake(SCREEN_WIDTH*arr.count, 0)];
            [scroll setContentOffset:CGPointMake(SCREEN_WIDTH * _index, 0) animated:NO];
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            scroll.alpha = 1;
            NSLog(@"");
            
            if (arr.count>0) {
                for (int i = 0; i<arr.count; i++) {
                    
                    UIImage *kuaifan = Img(@"icon_loading.png");
                    UIImageView * view = [[UIImageView alloc] initWithFrame:frame];
                    [scroll addSubview:view];
                    view.hidden = YES;
                    [view setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:kuaifan completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                        CGSize oSize = image.size;

                        CGFloat W =self.frame.size.width;
                        CGFloat H = image.size.height * SCREEN_WIDTH/oSize.width;
                        UIImageView * view11 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-W)/2, (SCREEN_HEIGHT-H)/2, W, H)];

                        view11.image = image;
                        
                        [imgArr addObject:image];
                        [frameArr addObject:NSStringFromCGRect(view11.frame)];
                        [imageArr addObject:view11];
                        
                        XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                        tmp.imageView = view11;
                        [scroll addSubview:tmp];
        
                            
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                }
            }
                
        [scroll setContentSize:CGSizeMake(SCREEN_WIDTH*arr.count, 0)];
        indexLb.text = [NSString stringWithFormat:@"%d/%lu",index+1,(unsigned long)arr.count];
        count = (int)arr.count;
            
            
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGestureRecognizer];
        
    }
    return self;
}


- (id)getCurrentView{
    
    return [imageArr objectAtIndex:index];
}

- (CGRect)getCurrentFrame{
    return CGRectFromString([frameArr objectAtIndex:index]);
}
- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    UIImageView * currentView = [self getCurrentView];
//    currentView.frame = [self getCurrentFrame];
//    NSLog(@"frame is %@",NSStringFromCGRect(currentView.frame));
//    [self addSubview:currentView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         scroll.alpha = 0;
//                         currentView.transform = CGAffineTransformIdentity;
//                         currentView.frame = startFrame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    index = scroll.contentOffset.x/SCREEN_WIDTH;
    indexLb.text = [NSString stringWithFormat:@"%d/%d",index+1,count];
}



- (void)sureButtonAction{
    UIImage * image = [imgArr objectAtIndex:index];
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self,  @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
}


//保存相片提示
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    if (error != NULL){
        [EFMyAutoAlertView showAlert:@"保存失败!"];
    }else{
        [EFMyAutoAlertView showAlert:@"保存成功!"];
    }
}




@end
