//
//  EFPageRequest.h
//  Symiles
//
//  Created by Jack on 3/7/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFRequest.h"

@interface EFPageRequest : EFRequest

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int size;

@end
