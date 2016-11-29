//
//  EFSelectCityVC.h
//  Dentist
//
//  Created by HqLee on 16/7/13.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "EFBaseViewController.h"
typedef void(^SelectHandler) (NSString *cityName,NSNumber*regionID);

@interface EFSelectCityVC : EFBaseViewController
- (instancetype)initWithSelectHandler:(SelectHandler)selectHandler;
@end
