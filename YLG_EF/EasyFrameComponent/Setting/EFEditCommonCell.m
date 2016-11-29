//
//  EFEditCommonCell.m
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFEditCommonCell.h"

@interface EFEditCommonCell()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end
@implementation EFEditCommonCell
#pragma mark --- life cycle
- (void)awakeFromNib{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    self.textLabel.backgroundColor = [UIColor clearColor];
}
#pragma mark --- setter
- (void)setCommonDict:(NSDictionary *)commonDict{
    _commonDict = commonDict;
    self.resultLabel.text = commonDict[@"placeHolder"];
    self.textLabel.text = commonDict[@"title"];
}

- (void)setResult:(NSString *)result{
    _result = [result copy];
    if (result.length != 0) {
        self.resultLabel.textColor = [UIColor blackColor];
    }
    self.resultLabel.text = result;
}
@end
