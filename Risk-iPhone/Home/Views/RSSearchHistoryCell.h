//
//  RSSearchHistoryCell.h
//  Risk
//
//  Created by ylgwhyh on 16/7/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSearchHistoryCell : UITableViewCell

@property (nonatomic,strong) UIView *line;
- (instancetype)initWithHistroy:(NSString *)_str;

@end
