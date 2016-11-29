//
//  KYDatePickerView.m
//  QuickFlip
//
//  Created by Jack on 5/6/15.
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

#import "KYDatePickerView.h"

@implementation KYDatePickerView

+ (KYDatePickerView *)openDatePickerWithSure : (DatePickerSureBlock)_sureBlock
                                      Cancel : (DatePickerCancelBlock)_cancelBlock
                                      Changed : (DatePickerDidChangeBlock)_changeBlock{
    KYDatePickerView *picker = [[KYDatePickerView alloc] initWithSure:_sureBlock Cancel:_cancelBlock Change:_changeBlock];
    [picker openPickerView];
    return picker;
}

- (instancetype)initWithSure : (DatePickerSureBlock)_sureBlock
                      Cancel : (DatePickerCancelBlock)_cancelBlock
                      Change : (DatePickerDidChangeBlock)_changeBlock
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216 + 44 * SCREEN_HALFSCALE_RATE)];
        [self addSubview:_pickerView];
        
        _menuBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 * SCREEN_HALFSCALE_RATE)];
        [_pickerView addSubview:_menuBarView];
        _menuBarView.backgroundColor = EF_MainColor;
        
        _sureBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBT setTitle:@"确定" forState:0];
        _sureBT.titleLabel.font = BoldFont(16*SCREEN_HALFSCALE_RATE);
        _sureBT.frame = CGRectMake(SCREEN_WIDTH-60*SCREEN_H_RATE, 0, 60*SCREEN_H_RATE, _menuBarView.frame.size.height);
        [_sureBT setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBT setTitleColor:BCWhiteColor(216, 1.0) forState:1];
        [_sureBT addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_menuBarView addSubview:_sureBT];
        
        _cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBT setTitle:@"取消" forState:0];
        _cancelBT.titleLabel.font = BoldFont(16*SCREEN_HALFSCALE_RATE);
        _cancelBT.frame = CGRectMake(10*SCREEN_W_RATE, 0, 60*SCREEN_H_RATE, _menuBarView.frame.size.height);
        [_cancelBT setTitleColor:[UIColor whiteColor] forState:0];
        [_cancelBT setTitleColor:BCWhiteColor(216, 1.0) forState:1];
        [_cancelBT addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_menuBarView addSubview:_cancelBT];
        
        self.datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,44*SCREEN_HALFSCALE_RATE,SCREEN_WIDTH,216)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_pickerView addSubview:_datePicker];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        
        sureBlock = _sureBlock;
        cancelBlock = _cancelBlock;
        changeBlock = _changeBlock;
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
    }
    return self;
}

- (void)backView:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.pickerView];
    if (point.y<0) {
        [self closePickerView];
    }
}

-(void)sureAction{
    UIDatePicker * control = _datePicker;
    NSDate* _date = control.date;
    if (sureBlock) {
        sureBlock(_date);
    }
    [self closePickerView];
}

-(void)cancelAction{
    if (cancelBlock) {
        cancelBlock();
    }
    [self closePickerView];
}

-(void)dateChanged:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    if (changeBlock) {
        changeBlock(_date);
    }
}

- (void)closePickerView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = BCWhiteColor(60, 0.0);
        _pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        sureBlock = nil;
        cancelBlock = nil;
        changeBlock = nil;
        [self removeFromSuperview];
    }];
}

- (void)openPickerView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = BCWhiteColor(60, 0.3);
        _pickerView.frame = CGRectMake(0, SCREEN_HEIGHT-_pickerView.frame.size.height, SCREEN_WIDTH, _pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}


@end
