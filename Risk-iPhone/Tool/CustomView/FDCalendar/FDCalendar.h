//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^FDCalendarCompleteBlock) (NSDate *date);

@interface FDCalendar : UIView

- (instancetype)initWithFrame:(CGRect)frame  currentDate:(NSDate *)date fdCalendarCompleteBlock:(FDCalendarCompleteBlock)block;

@end
