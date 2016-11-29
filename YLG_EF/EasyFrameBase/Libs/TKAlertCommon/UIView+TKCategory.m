//
//  UIViewAdditions.m
//

#import "UIView+TKCategory.h"


@implementation UIView (TKCategory)


- (void) addSubviewToBack:(UIView*)view{
	[self addSubview:view];
	[self sendSubviewToBack:view];
}


- (void) roundOffFrame{
	self.frame = CGRectMake((NSInteger)self.frame.origin.x, (NSInteger)self.frame.origin.y, (NSInteger)self.frame.size.width, (NSInteger)self.frame.size.height);
}


+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius{
	CGContextRef context = UIGraphicsGetCurrentContext();

	
	CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );

	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);
}






@end
