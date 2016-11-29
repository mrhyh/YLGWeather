//
//  EFShopCartHeadView.h
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>

#if NS_BLOCKS_AVAILABLE

typedef void (^EFShopCartHeadViewBlock)(BOOL isSelected);
typedef void (^EFShopCartHeadViewSelectedBlock)(BOOL isSelected);

#endif

@interface EFShopCartHeadView : UIView{


    __strong EFShopCartHeadViewBlock callBack;
}

@property (nonatomic, strong) KYMHButton *button;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHImageView *indicatorImageView;


- (instancetype)initWithFrame:(CGRect)frame Name:(NSString *)name  SelectBlock:(EFShopCartHeadViewSelectedBlock)block;

//这个方法不用
- (void)EFShopCartHeadViewSelectedWithBlock:(EFShopCartHeadViewSelectedBlock)block;
@end
