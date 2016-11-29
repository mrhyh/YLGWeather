//
//  RSDataSecondCenterVC.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/10.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

@interface RSDataSecondCenterVC : EFBaseViewController

@property (nonatomic,copy) NSString * keyWord;

@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, assign) int categoryId;

/** * 分页 */
@property (assign, nonatomic) int pageCount;

@end
