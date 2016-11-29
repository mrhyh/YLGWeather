//
//  KYDatePickerView.h
//  QuickFlip
//
//  Created by Jack on 5/6/15.
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^DatePickerSureBlock)(NSDate *date);
typedef void (^DatePickerCancelBlock)(void);
typedef void (^DatePickerDidChangeBlock)(NSDate *date);
#endif

@interface KYDatePickerView : UIView{
    
    DatePickerSureBlock sureBlock;
    DatePickerCancelBlock cancelBlock;
    DatePickerDidChangeBlock changeBlock;
    
}


@property (nonatomic,strong)UIView *pickerView;
@property (nonatomic,strong)UIView *menuBarView;
@property (nonatomic,strong)UIButton *cancelBT;
@property (nonatomic,strong)UIButton *sureBT;
@property (nonatomic,strong)UIPickerView *picker;

@property (nonatomic,strong)UIDatePicker *datePicker;

+ (KYDatePickerView *)openDatePickerWithSure : (DatePickerSureBlock)_sureBlock
                        Cancel : (DatePickerCancelBlock)_cancelBlock
                        Changed : (DatePickerDidChangeBlock)_changeBlock;

@end
