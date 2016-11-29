//
//  EF_MyOrderVC.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBaseViewController.h"

typedef void(^EFMyOrderVCBlock)(BOOL isSuccess) ;

@interface EFMyOrderVC : EFBaseViewController
- (instancetype)initWithCallBack:(EFMyOrderVCBlock)callBack;
/** * 分页 */
@property (assign, nonatomic) int pageCount;
@property (nonatomic, copy) EFMyOrderVCBlock completeBlock;
@end
