//
//  RSSearchVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

typedef void (^RSSearchVCClickBlack) (NSString *selectString, NSInteger objectId);

@interface RSSearchVC : EFBaseViewController 

/** * 分页 */
@property (assign, nonatomic) int pageCount;

@property (assign, nonatomic) BOOL isRSVAPatientArchiveVCBool; //YES，代表是从随访档案跳转过来的，cell点击不跳转

- (void )RSSearchVCClickBlack:(RSSearchVCClickBlack )block;


@end
