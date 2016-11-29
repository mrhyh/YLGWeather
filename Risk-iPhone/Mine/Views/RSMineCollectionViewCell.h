//
//  RSMineCollectionViewCell.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSMineCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) int  index;

@property (nonatomic,strong) NSString * imageName;
@property (nonatomic,strong) NSString * titleStr;

- (instancetype)initWithFrame:(CGRect)frame;

@end
