//
//  LocationUtil.m
//  QuickFlip
//
//  Created by 李传政 on 15-4-21.
//  Copyright (c) 2015年 KingYon LLC. All rights reserved.
//

#import "LocationUtil.h"

@implementation LocationUtil

@synthesize currentCoordinate;

+ (LocationUtil*)shareInstance{
    static LocationUtil *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[LocationUtil alloc] init];
    });
    return sharedManager;
}

-(id)init{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //The desired location accuracy.
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //Specifies the minimum update distance in meters.
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        //定位服务是否可用
        BOOL enable = [CLLocationManager locationServicesEnabled];
        //是否具有定位权限
        int status = [CLLocationManager authorizationStatus];
        if(!enable || status<3){
            //请求权限
            if (CurrentSystemVersion>=8) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
        [self.locationManager startUpdatingLocation];
        
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(-1000, 1000, 20, 20)];
        [[UIApplication sharedApplication].keyWindow addSubview:_mapView];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        _mapView.delegate = self;
        
        _isNotice = NO;
    }
    return self;
}

- (void)startUpdateLocationWithAutoClose{
    self.isAutoClose = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}

- (void)startUpdateLocation{
    self.isAutoClose = NO;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}

- (void)stopUpdateLocation{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager stopUpdatingLocation];
    
    _mapView.userTrackingMode = MKUserTrackingModeNone;
    _mapView.showsUserLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLLocationCoordinate2D newCoor = [WGS84TOGCJ02 wgs84ToGcj02:newLocation.coordinate];
//    NSLog(@"-----new location-----%d-------CLLocationManager -------  : %f,%f",_locateCount,newCoor.latitude,newCoor.longitude);
    [self setNewCoordinate:newCoor];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    NSLog(@"-----new location-----%d-------MKMapView ---------------- : %f,%f",_locateCount,userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    [self setNewCoordinate:userLocation.coordinate];
}

- (void)setNewCoordinate:(CLLocationCoordinate2D)_newCoordinate{
    self.currentCoordinate = _newCoordinate;
    _locateCount ++;
    if (_isNotice == NO) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LocationLoadSuccess" object:nil];
        _isNotice =  YES;
    }
    if (_isAutoClose && _locateCount >= 5) {
        _locateCount = 0;
        [self stopUpdateLocation];
    }
}

@end
