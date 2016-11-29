//
//  TKAlertCenter.h
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TKAlertView;
@interface TKAlertCenter : NSObject {
	NSMutableArray *_alerts;
	BOOL _active;
	TKAlertView *_alertView;
	CGRect _alertFrame;
    int     Times;
}

+ (TKAlertCenter*) defaultCenter;

- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image;
- (void) postAlertWithMessage:(NSString *)message;

@end