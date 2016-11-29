//
//  HYDActivityProgressView.h
//  WildWestPoker_iPhone
//
//  Created by  on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDActivityMessageView.h"

@interface HYDActivityProgressView : HYDActivityMessageView{
    UIProgressView          *progress;
}

- (void)updateProgress : (CGFloat)_progress;

+ (HYDActivityProgressView *)currentIndicator;

+ (void)showActivityProgress : (CGFloat)_progress;

@end
