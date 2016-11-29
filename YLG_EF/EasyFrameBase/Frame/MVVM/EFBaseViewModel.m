//
//  EFBaseViewModel.m
//  Symiles
//
//  Created by Jack on 3/7/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import "EFBaseViewModel.h"

@implementation EFBaseViewModel

- (instancetype)initWithViewController : (NSObject *)_viewcontroller
{
    self = [super init];
    if (self) {
        self.viewController = _viewcontroller;
        self.requests = [NSMutableArray array];
    }
    return self;
}


- (void)addRequest : (EFRequest *)_request{
    [self.requests addObject:_request];
}


- (void)delRequest : (EFRequest *)_request{
    [self.requests removeObject:_request];
}

- (void)delRequestWithTag : (NSInteger)_tag{
    for (EFRequest *request in self.requests) {
        if (request.tag == _tag) {
            [self.requests removeObject:request];
            break;
        }
    }
}

- (void)cancelRequest : (EFRequest *)_request{
    [_request cancelRequest];
}

- (void)cancelAndRemoveRequest : (EFRequest *)_request{
    [_request cancelRequest];
    [self.requests removeObject:_request];
}

- (void)cancelAndRemoveRequestWithTag : (int)_tag{
    for (EFRequest *request in self.requests) {
        if (request.tag == _tag) {
            [self cancelAndRemoveRequest:request];
            break;
        }
    }
}

- (void)cancelAndClearAll{
    if (self.requests && [self.requests count] > 0) {
        for (EFRequest *request in self.requests) {
            [self cancelRequest:request];
        }
        [self.requests removeAllObjects];
    }
    self.viewController = nil;
}

- (void)startCallBack:(RequestCallBackBlock)_callBack Request : (EFRequest *)_request WithTag : (int)_tag{
    [self cancelAndRemoveRequestWithTag:_tag];
    _request.tag = _tag;
    [self addRequest:_request];
    [_request startCallBack:_callBack];
}

- (void)startWithJsonCallBack:(RequestCallBackBlock)_callBack Request : (EFRequest *)_request WithTag : (int)_tag{
    [self cancelAndRemoveRequestWithTag:_tag];
    _request.tag = _tag;
    [self addRequest:_request];
    [_request startWithJsonCallBack:_callBack];
}

@end

@implementation NSObject(EFViewModel)

-(void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result{
    
}

@end
