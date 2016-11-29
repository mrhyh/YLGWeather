//
//  RSMedicineDetailMenuCell.m
//  Risk-iPhone
//
//  Created by ylgwhyh on 16/9/13.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "RSMedicineDetailMenuCell.h"

@interface RSMedicineDetailMenuCell ()

@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation RSMedicineDetailMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat spaceToLeft = 10;
    UIColor *labelTextColor = [UIColor blackColor];
    
    _nameLabel = [[KYMHLabel alloc] initWithTitle:@"" BaseSize:CGRectMake(10, 0, SCREEN_WIDTH , 0) LabelColor:[UIColor whiteColor] LabelFont:middleFontSize LabelTitleColor:labelTextColor TextAlignment:NSTextAlignmentLeft];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    NSArray *views = @[_nameLabel, _lineView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _nameLabel.sd_layout
    .leftSpaceToView (contentView, spaceToLeft )
    .rightSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(contentView,10)
    .bottomSpaceToView(contentView,10);
    
    _lineView.sd_layout
    .leftSpaceToView(contentView,5)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .heightIs(0.5);
}

- (void)setTextString:(NSString *)textString {
    
    if (textString.length > 2) {
        NSString *firstStr = [textString substringToIndex:1];
        if( ![firstStr isEqualToString:@"【"] ) {
            firstStr = [NSString stringWithFormat:@"  %@",textString];
        }
        _nameLabel.text = textString;
    }else {
        _nameLabel.text = textString;
    }
}

@end
