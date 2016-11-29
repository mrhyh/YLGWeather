//
//  AllHealthModel.h
//  Risk
//
//  Created by Cherie Jeong on 16/8/3.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Children;

@interface AllHealthModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, strong) NSArray<Children *> *children;

@end

@interface Children : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic,strong) NSArray<Children *> * children;

@property (nonatomic, assign) int integer;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL nextPage;

@end


//@interface SecondChildren : NSObject
//
//@property (nonatomic, copy) NSString *name;
//
//@property (nonatomic, assign) NSInteger objectId;
//
//@property (nonatomic, assign) BOOL nextPage;
//
//@end