//
//  EFPageViewModel.h
//  Symiles
//
//  Created by Jack on 3/7/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFBaseViewModel.h"

@interface EFPageViewModel : EFBaseViewModel

@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) int page;
@property (nonatomic,assign) int size;
@property (nonatomic,assign) BOOL hasNext;
@property (nonatomic,assign) int total;

- (BOOL)hasNext;

@end
