//
//  SecondCollectionViewCell.h
//  Risk
//
//  Created by Cherie Jeong on 16/7/6.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSDateCenterModel.h"

@interface SecondCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSIndexPath * indexPath;

@property (nonatomic, strong) FilesitemsModel *model;


@end
