//
//  EFOrderStatusCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/14.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFOrderStatusCell.h"

@interface EFOrderStatusCell ()

@property (nonatomic, strong) KYMHImageView *leftImageView;
@property (nonatomic, strong) KYMHImageView *middleImageView;
@property (nonatomic, strong) KYMHImageView *rightImageView;

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) KYMHLabel *leftLabel;
@property (nonatomic, strong) KYMHLabel *middleLabel;
@property (nonatomic, strong) KYMHLabel *rightLabel;

@end

@implementation EFOrderStatusCell {
    
    CGFloat imageViewH ;
    CGFloat spaceToLeft ;
    CGFloat labelH ;
    CGFloat labelW ;
    CGFloat smallImageViewH;
    CGFloat leftImageToLeftSpace;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//1. 创建控件
- (void)setup {
    
    CGFloat cellH = 90;
    
     imageViewH = 17;
     spaceToLeft = 10;
     labelH = 20;
     labelW = (SCREEN_WIDTH-3*spaceToLeft)/3;
     smallImageViewH = 6;
     leftImageToLeftSpace = 40*SCREEN_W_RATE;
    
    _leftImageView = [KYMHImageView new];
    _middleImageView = [KYMHImageView new];
    _rightImageView = [KYMHImageView new];
    
    _leftLineView = [UIView new];
    _rightLineView = [UIView new];
    
    CGFloat fontSize = 12;
    _leftLabel = [KYMHLabel new];
    _leftLabel.textColor = EF_TextColor_TextColorSecondary;
    _leftLabel.font = Font(fontSize);
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    
    _middleLabel = [KYMHLabel new];
    _middleLabel.textColor = EF_TextColor_TextColorSecondary;
    _middleLabel.font = Font(fontSize);
    _middleLabel.textAlignment = NSTextAlignmentCenter;
    
    _rightLabel = [KYMHLabel new];
    _rightLabel.textColor = EF_TextColor_TextColorSecondary;
    _rightLabel.font = Font(fontSize);
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    //更新数据
    _leftLabel.text = @"订单已提交";
    _middleLabel.text = @"商品已经发货";
    _rightLabel.text = @"已送达";
    
    _leftImageView.backgroundColor = EF_MainColor;
    _middleImageView.backgroundColor = EF_MainColor;
    _rightLabel.textColor = EF_TextColor_TextColorSecondary;
    _rightLineView.backgroundColor = EF_TextColor_TextColorSecondary;
    _rightImageView.backgroundColor = EF_TextColor_TextColorSecondary;
    
    //布局
    NSArray *views = @[_leftLabel, _middleLabel, _rightLabel, _leftImageView, _middleImageView, _rightLineView, _leftLineView, _rightLineView, _rightImageView];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;

    _middleImageView.sd_layout
    .topSpaceToView(contentView, (cellH -10 - (labelH+imageViewH+spaceToLeft))/2)
    .centerXIs(SCREEN_WIDTH/2)
    .widthIs(imageViewH)
    .heightIs(imageViewH);
    _middleImageView.layer.cornerRadius = imageViewH/2;
    
    _middleLabel.sd_layout
    .topSpaceToView (_middleImageView, spaceToLeft)
    .centerXIs(SCREEN_WIDTH/2)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _leftImageView.sd_layout
    .centerYEqualToView(_middleImageView)
    .leftSpaceToView(contentView, leftImageToLeftSpace)
    .widthIs(smallImageViewH)
    .heightIs(smallImageViewH);
    _leftImageView.layer.cornerRadius = smallImageViewH/2;
    
    _leftLineView.sd_layout
    .centerYEqualToView(_middleImageView)
    .leftSpaceToView(_leftImageView, spaceToLeft)
    .rightSpaceToView (_middleImageView, spaceToLeft)
    .heightIs(2);
    _leftLineView.backgroundColor = EF_MainColor;
    
    _leftLabel.sd_layout
    .topSpaceToView(_middleImageView, spaceToLeft)
    .centerXEqualToView(_leftImageView)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _rightImageView.sd_layout
    .centerYEqualToView(_middleImageView)
    .rightSpaceToView(contentView, leftImageToLeftSpace)
    .widthIs(smallImageViewH)
    .heightIs(smallImageViewH);
    _rightImageView.layer.cornerRadius = smallImageViewH/2;
    _rightImageView.backgroundColor = EF_TextColor_TextColorSecondary;

    _rightLabel.sd_layout
    .topSpaceToView(_middleImageView, spaceToLeft)
    .centerXEqualToView(_rightImageView)
    .widthIs(labelW)
    .heightIs(labelH);
    
    _rightLineView.sd_layout
    .centerYEqualToView(_middleImageView)
    .leftSpaceToView(_middleImageView, spaceToLeft)
    .rightSpaceToView (_rightImageView, spaceToLeft)
    .heightIs(2);
    _rightLineView.backgroundColor = EF_TextColor_TextColorSecondary;
    
}

- (void)setOrderStatus:(NSString *)orderStatus {
    
    if( [orderStatus isEqualToString:@"UN_SHIP"] ) {
        
        _leftImageView.backgroundColor = EF_MainColor;
        _leftLineView.backgroundColor = EF_TextColor_TextColorSecondary;
        _middleImageView.backgroundColor = EF_TextColor_TextColorSecondary;
        _rightLabel.textColor = EF_TextColor_TextColorSecondary;
        _rightLabel.textColor = EF_TextColor_TextColorSecondary;
        _leftLabel.textColor = EF_MainColor;
        _middleLabel.textColor = EF_TextColor_TextColorSecondary;
        _rightImageView.backgroundColor = EF_TextColor_TextColorSecondary;
        
        _leftImageView.sd_layout
        .widthIs(imageViewH)
        .heightIs(imageViewH);
        _leftImageView.layer.cornerRadius = imageViewH/2;
        
        _middleImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _middleImageView.layer.cornerRadius = smallImageViewH/2;
        
        _rightImageView.sd_layout
        .centerXIs(SCREEN_WIDTH/2)
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _rightImageView.layer.cornerRadius = smallImageViewH/2;
        
    }else if ( [orderStatus isEqualToString:@"SHIPPED"] ) {
        
        _leftImageView.backgroundColor = EF_MainColor;
        _middleImageView.backgroundColor = EF_MainColor;
        _rightLabel.textColor = EF_TextColor_TextColorSecondary;
        _leftLabel.textColor = EF_TextColor_TextColorSecondary;
        _middleLabel.textColor = EF_MainColor;
        _rightLineView.backgroundColor = EF_TextColor_TextColorSecondary;
        _rightImageView.backgroundColor = EF_TextColor_TextColorSecondary;
        
        _leftImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _leftImageView.layer.cornerRadius = smallImageViewH/2;
        
        _middleImageView.sd_layout
        .widthIs(imageViewH)
        .heightIs(imageViewH);
        _middleImageView.layer.cornerRadius = imageViewH/2;
        
        _rightImageView.sd_layout
        .centerXIs(SCREEN_WIDTH/2)
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _rightImageView.layer.cornerRadius = smallImageViewH/2;
        
    }else if ( [orderStatus isEqualToString:@"UN_COMMENTED"] || [orderStatus isEqualToString:@"APPLY_AFTER_SALE"] || [orderStatus isEqualToString:@"FINISHED"] ) {
        _leftImageView.backgroundColor = EF_MainColor;
        _leftLineView.backgroundColor = EF_MainColor;
        _middleImageView.backgroundColor = EF_MainColor;
        _rightLabel.textColor = EF_MainColor;
        _leftLabel.textColor = EF_TextColor_TextColorSecondary;
        _middleLabel.textColor = EF_TextColor_TextColorSecondary;
        _rightLineView.backgroundColor = EF_MainColor;
        _rightImageView.backgroundColor = EF_MainColor;
        
        
        _leftImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _leftImageView.layer.cornerRadius = smallImageViewH/2;
        
        _middleImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _middleImageView.layer.cornerRadius = smallImageViewH/2;
        
        _rightImageView.sd_layout
        .centerXIs(SCREEN_WIDTH/2)
        .widthIs(imageViewH)
        .heightIs(imageViewH);
        _rightImageView.layer.cornerRadius = imageViewH/2;

        
    }else {//UN_PAYED CANCELD
        _leftImageView.backgroundColor = EF_MainColor;
        _leftLineView.backgroundColor = EF_MainColor;
        _middleImageView.backgroundColor = EF_MainColor;
        _rightLabel.textColor = EF_TextColor_TextColorSecondary;
        _leftLabel.textColor = EF_TextColor_TextColorSecondary;
        _middleLabel.textColor = EF_TextColor_TextColorSecondary;
        _rightLineView.backgroundColor = EF_MainColor;
        _rightImageView.backgroundColor = EF_MainColor;
        
        
        _leftImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _leftImageView.layer.cornerRadius = smallImageViewH/2;
        
        _middleImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _middleImageView.layer.cornerRadius = smallImageViewH/2;
        
        _rightImageView.sd_layout
        .widthIs(smallImageViewH)
        .heightIs(smallImageViewH);
        _rightImageView.layer.cornerRadius = smallImageViewH/2;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
