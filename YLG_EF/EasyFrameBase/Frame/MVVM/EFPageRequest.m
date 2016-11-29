//
//  EFPageRequest.m
//  Symiles
//
//  Created by Jack on 3/7/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFPageRequest.h"

@implementation EFPageRequest

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [dic setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",self.size] forKey:@"size"];
    self.params = dic;
    [super startCallBack:_callBack];
}

@end
