//
//  EFMineProfileCell.m
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFMineProfileCell.h"
#import "UserModel.h"
@interface EFMineProfileCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (copy, nonatomic)NSString      * defaultStr1;


@end
@implementation EFMineProfileCell
#pragma mark --- life cycle
- (void)awakeFromNib{
    
}



#pragma mark --- setter
- (void)setProfileDict:(NSDictionary *)profileDict{
    _profileDict = profileDict;
    _defaultStr = @"介绍一下自己吧";
    _defaultStr1 = @"140";
    UIColor * color = EF_TextColor_TextColorPrimary;
    UIColor * color1 = EF_TextColor_TextColorDisable;

    if ([UserModel ShareUserModel].sign.length>0) {
        _defaultStr = [UserModel ShareUserModel].sign;
        _defaultStr1 = [NSString stringWithFormat:@"%ld",140-[UserModel ShareUserModel].sign.length];
    }

    self.nameLabel.text = profileDict[@"title"];
    self.numLabel.text = _defaultStr1;
    self.profileInputView.text = _defaultStr;
    self.profileInputView.delegate = self;
    self.profileInputView.textColor = color1;
    if (![self.profileInputView.text isEqualToString:@"介绍一下自己吧"]) {
        self.profileInputView.textColor = color;
    }
}


#pragma mark TextViewDelegate



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"介绍一下自己吧"]) {
        textView.text = @"";
        self.profileInputView.textColor = EF_TextColor_TextColorPrimary;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([UIUtil isEmptyStr:textView.text]) {
        textView.text = @"介绍一下自己吧";
        self.profileInputView.textColor = EF_TextColor_TextColorSecondary;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger existedLength = textView.text.length;
    NSLog(@"existedLength%ld",(long)existedLength);
    _defaultStr1 = [NSString stringWithFormat:@"%ld",140-existedLength];
    _defaultStr = textView.text;
    self.numLabel.text = _defaultStr1;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length == 0)
        return YES;
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength > 140) {
        [UIUtil alert:@"最多输入140个字"];
        return NO;
    }
    NSLog(@"existedLength%ld",(long)existedLength);
    NSLog(@"selectedLength%ld",(long)selectedLength);
    NSLog(@"replaceLength%ld",(long)replaceLength);
    _defaultStr1 = [NSString stringWithFormat:@"%ld",139-existedLength];
    _defaultStr = textView.text;
    self.numLabel.text = _defaultStr1;
    return YES;
}

@end
