//
//  LocationUtil.h
//  QuickFlip
//
//  Created by 李传政 on 15-4-21.
//  Copyright (c) 2015年 KingYon LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"
#import <MapKit/MapKit.h>

@interface LocationUtil : NSObject<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic,retain)CLLocationManager* locationManager;
@property (nonatomic,assign)CLLocationCoordinate2D currentCoordinate;
@property (nonatomic,assign)BOOL isAutoClose;
@property (nonatomic,assign)int locateCount;
@property (nonatomic,assign)BOOL isNotice;

+ (LocationUtil*)shareInstance;


@end
