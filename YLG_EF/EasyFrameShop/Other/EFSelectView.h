//
//  CitySelectView.h
//  pdb
//
//  Created by mini珍 on 15/12/9.
//  Copyright © 2015年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFMallModel.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^EFSelectViewBlock)(CategoryModel * category);
#endif

@interface EFSelectView : UIView
{
    __strong EFSelectViewBlock callBack;
}
- (instancetype)initWithFrame:(CGRect)frame ObjectId:(int)objectId Array:(NSMutableArray*)array andCity:(NSString *)city andSelectBlock:(EFSelectViewBlock)block;
@end
