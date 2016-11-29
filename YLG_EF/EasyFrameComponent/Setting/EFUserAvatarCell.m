//
//  EFUserAvatarCell.m
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFUserAvatarCell.h"
@interface EFUserAvatarCell()
@end

@implementation EFUserAvatarCell
#pragma mark --- life cycle
- (void)awakeFromNib{
//    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width * 0.5;
    self.avatarImageView.layer.masksToBounds = YES;
    self.textLabel.backgroundColor = [UIColor clearColor];
}
#pragma mark --- setter
- (void)setAvatarDict:(NSDictionary *)avatarDict{
    _avatarDict = avatarDict;
    self.avatarImageView.image = [UIImage imageNamed:@"resource.bundle/reg_weixin.png"];
    self.textLabel.text = avatarDict[@"title"];
}

- (void)setAvatarImage:(UIImage *)avatarImage{
    _avatarImage = avatarImage;
    self.avatarImageView.image = avatarImage;
}
@end
