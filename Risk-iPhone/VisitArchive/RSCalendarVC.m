//
//  RSCalendarVC.m
//  FDCalendarDemo
//
//  Created by ylgwhyh on 16/7/11.
//  Copyright © 2016年 fergusding. All rights reserved.
//

#import "RSCalendarVC.h"
#import "FDCalendar.h"

@interface RSCalendarVC ()

@property (nonatomic, strong) FDCalendar *calendarView;

@end

@implementation RSCalendarVC

- (BOOL)willDealloc {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)  {
        [self initIpadUI];
    }else {
        [self initIphoneUI];
    }
    
}

- (void) initData {
    
}

- (void) initIpadUI {
    
    __weak typeof(self) weakSelf = self;
    
    if(_calendarView == nil) {
        _calendarView = [[FDCalendar alloc] initWithFrame:CGRectMake(0, 0, 330, 290) currentDate:[NSDate date] fdCalendarCompleteBlock:^(NSDate *date) {
            if ([weakSelf.delegate respondsToSelector:@selector(datePicker:didSelectDate:)] ) {
                [weakSelf.delegate datePicker:self didSelectDate:date];
            }
        } ];
        
        // 设置控制器在popover中显示的尺寸跟图片 一样
        self.preferredContentSize = self.calendarView.frame.size;
        [self.view addSubview:_calendarView];
    }
}


- (void) initIphoneUI {
    
    __weak typeof(self) weakSelf = self;
    
    if(_calendarView == nil) {
        _calendarView = [[FDCalendar alloc] initWithFrame:CGRectMake(0, 0, 330, 290) currentDate:[NSDate date] fdCalendarCompleteBlock:^(NSDate *date) {
            if ([weakSelf.delegate respondsToSelector:@selector(datePicker:didSelectDate:)] ) {
                [weakSelf.delegate datePicker:self didSelectDate:date];
            }
        } ];
        
        _calendarView.center = self.view.center;
        // 设置控制器在popover中显示的尺寸跟图片 一样
        self.preferredContentSize = self.calendarView.frame.size;
        [self.view addSubview:_calendarView];
    }
}

- (void )dealloc {
    NSLog(@"RSCalendarVC-Dealloc");
}
@end
