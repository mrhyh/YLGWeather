//
//  EFBaseViewModel.h
//  Symiles
//
//  Created by Jack on 3/7/16.
//  Copyright © 2016 KingYon LTD. All rights reserved.
//

#import <YYModel/YYModel.h>
#import "EFRequest.h"
typedef NSUInteger EFViewControllerCallBackAction;

@interface NSObject(EFViewModel)

-(void)callBackAction:(EFViewControllerCallBackAction)action Result:(NetworkModel *)result;

@end

@interface EFBaseViewModel : NSObject

@property (nonatomic,strong)NSMutableArray *requests;
@property (nonatomic,assign)NSObject *viewController;


- (instancetype)initWithViewController : (NSObject *)_viewcontroller;

- (void)addRequest : (EFRequest *)_request;
- (void)delRequest : (EFRequest *)_request;
- (void)delRequestWithTag : (NSInteger)_tag;
- (void)cancelAndClearAll;
- (void)cancelRequest : (EFRequest *)_request;
- (void)cancelAndRemoveRequest : (EFRequest *)_request;
- (void)cancelAndRemoveRequestWithTag : (int)_tag;


- (void)startCallBack:(RequestCallBackBlock)_callBack Request : (EFRequest *)_request WithTag : (int)_tag;

/*POST with headers and HTTP Body*/
- (void)startWithJsonCallBack:(RequestCallBackBlock)_callBack Request : (EFRequest *)_request WithTag : (int)_tag;
@end
