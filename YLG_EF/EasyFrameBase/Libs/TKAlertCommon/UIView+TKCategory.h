//
//  UIViewAdditions.h
//



#import <UIKit/UIKit.h>

@interface UIView (TKCategory)

- (void) addSubviewToBack:(UIView*)view;

- (void) roundOffFrame;


// DRAW ROUNDED RECTANGLE
+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;


@end



