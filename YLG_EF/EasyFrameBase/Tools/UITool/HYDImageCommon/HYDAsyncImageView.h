//
//  HYDAsyncImageView.h
//  Exam
//
//  Created by  on 6/12/12.
//  V 1.0
//

#import <UIKit/UIKit.h>



@protocol HYDAsyncImageViewDelegate <NSObject>

-(void)AsyncImageLoadFinish : (UIImage *)_image Sender : (id)sender;
-(void)AsyncImageLoadFaild : (id)sender;

@end


@interface HYDAsyncImageView : UIView{

    NSString                    * imageName;
    BOOL                          isProgress;
    //HYDActivityIndicatorView    * indicatorView;
    UIImage                     * useImage;
}

@property (nonatomic,retain)NSString        * imageName;
//@property (nonatomic,retain)ASIHTTPRequest  * imageRequest;
@property (nonatomic,assign)id<HYDAsyncImageViewDelegate>  delegate;
@property (nonatomic,retain)UIImage        * useImage;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame Image : (UIImage *)_image;
//通过图片的frame和异步加载的图片地址来初始化图片视图，加载时显示默认的加载框
- (id)initWithFrame:(CGRect)frame AndUrl : (NSString *)_url;
//通过图片的frame和异步加载的图片地址来初始化图片视图，加载时显示加载进度条
- (id)initWithFrame:(CGRect)frame AndUrl : (NSString *)_url ShowProgress : (BOOL)_isProgress;

- (id)initWithFrame:(CGRect)frame AndUrl : (NSString *)_url ShowProgress : (BOOL)_isProgress Delegate : (id)_delegate;


-(void)AsyncLoadImageWithUrlStr : (NSString *)_urlStr;
-(void)AsyncLoadImageWithUrl : (NSURL *)_url;


//加载成功后的图片处理方法，子类进行扩展时，重写此方法即可
-(void)AsyncImageLoadFinish : (UIImage *)_image;

-(void)setImage : (UIImage *)_image;
//停止加载图片
- (void)stopLoadImage;
- (void)hiddenActivity;

- (UIImage *)getDefaultImage;
- (UIImage *)getImage;
@end
