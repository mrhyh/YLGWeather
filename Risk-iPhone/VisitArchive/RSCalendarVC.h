//
//  RSCalendarVC.h
//  FDCalendarDemo
//
//  Created by ylgwhyh on 16/7/11.
//  Copyright © 2016年 fergusding. All rights reserved.
//  日历-日期选择

#import <UIKit/UIKit.h>


@class RSCalendarVC;

@protocol RSCalendarVCDelegate <NSObject>

@optional

- (void)datePicker:(RSCalendarVC *)rsCalendarVC didSelectDate:(NSDate *)date;

@end

@interface RSCalendarVC : UIViewController

@property (weak, nonatomic) id<RSCalendarVCDelegate> delegate;

@end
