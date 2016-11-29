//
//  YJ_ImageVC.h
//  KYiOS
//
//  Created by MH on 16/4/28.
//  Copyright © 2016年 mini珍. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YJ_ImageVCBlock)(NSMutableArray * arr) ;
@interface YJ_ImageVC : UIViewController
@property (nonatomic,copy)YJ_ImageVCBlock imageBlock;
- (instancetype)initWithImageArr:(NSMutableArray*)_array HeightArr:(NSMutableArray*)_heightarray Index:(int)_index SelectCallBack : (YJ_ImageVCBlock)_callBack;

- (instancetype)initWithImage:(UIImage*)_image;
@end
