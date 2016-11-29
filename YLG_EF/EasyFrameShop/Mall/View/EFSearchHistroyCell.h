//
//  SearchHistroyCell.h
//  hujinrong
//
//  Created by Cherie Jeong on 16/5/3.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFSearchHistroyCell : UITableViewCell

@property (nonatomic,strong) UIView *line;

- (instancetype)initWithHistroy:(NSString *)_str;

@end
