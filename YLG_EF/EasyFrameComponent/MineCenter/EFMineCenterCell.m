//
//  EFMineCenterCell.m
//  demo
//
//  Created by HqLee on 16/5/19.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFMineCenterCell.h"

@interface EFMineCenterCell()

@property (nonatomic, strong) KYMHImageView * ky_imageView;
@property (nonatomic, strong) KYMHLabel *titleLB;
@property (nonatomic, strong) KYMHLabel *subTitleLB;
@property (nonatomic, strong) KYMHImageView *accessoryImgView;
@property (nonatomic, strong) KYMHButton *button;
@property (nonatomic, weak) UIView *separateLine;
@end
@implementation EFMineCenterCell
- (void)setMineCenterDict:(NSDictionary *)mineCenterDict{
    _mineCenterDict = mineCenterDict;
    self.textLabel.text = mineCenterDict[@"title"];
    self.imageView.image = Img(mineCenterDict[@"imageName"]);
    if ([mineCenterDict[@"accessoryView"] isEqualToString:@"arrow"]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self separateLine];
}

- (UIView *)separateLine{
    if (!_separateLine) {
        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(10, 44.5, SCREEN_WIDTH-10, 0.5)];
        separateLine.backgroundColor = EF_TextColor_TextColorDisable;
        [self.contentView addSubview:separateLine];
        _separateLine = separateLine;
    }
    return _separateLine;
}
@end