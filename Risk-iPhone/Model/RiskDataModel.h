//
//  RiskDataModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskDataModel : NSObject

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, assign) NSInteger readNumberInteger;
@property (nonatomic, assign) CGFloat memorySizeFloat;
@property (nonatomic, copy) NSString *imageUrlString;

@end
