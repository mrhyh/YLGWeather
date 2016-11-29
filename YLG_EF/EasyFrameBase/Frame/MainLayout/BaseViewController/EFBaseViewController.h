//
//  QFBaseViewController.h
//  QuickFix
//
//  Created by Jack on 4/8/15.
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface EFBaseViewController : UIViewController<UIGestureRecognizerDelegate>{
    
}
@property (nonatomic,copy)NSString *plistPath;
- (void)skinChange;
@end
