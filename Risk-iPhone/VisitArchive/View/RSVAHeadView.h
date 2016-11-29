//
//  RSVAHeadView.h
//  Risk
//
//  Created by ylgwhyh on 16/7/27.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSVAHeadView : UIView

@property (nonatomic, strong) KYMHLabel *numberLabel;
@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *phoneNumLabel;
@property (nonatomic, strong) KYMHLabel *mensesDataLabel;
@property (nonatomic, strong) KYMHLabel *estimateTimeLabel;
@property (nonatomic, strong) KYMHLabel *pregnantTimeLabel;
@property (nonatomic, strong) KYMHLabel *babyNumberLabel;
@property (nonatomic, strong) KYMHLabel *exposureFactorLabel;

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;

- (id) initWithFrame:(CGRect)frame;

@end
