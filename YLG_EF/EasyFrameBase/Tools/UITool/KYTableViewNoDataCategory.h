//
//  KYTableViewNoDataCategory.h
//  QuickFlip
//
//  Created by Jack on 5/7/15.
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

//#import "KYPickerView.h"

@interface UITableView (KYTableViewNoDataCategory)

- (void)addNoDataView;
- (void)addNoDataViewStr:(NSString *)_str;
- (void)removeNoDataView;

@end
