//
//  MyLocation.h
//  Diners Guide
//
//  Created by Clay Ewing on 10/5/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinates:(CLLocationCoordinate2D) coordinate sid:(NSString*)pid legality:(NSString*)legal;
- (MKMapItem*)mapItem;

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *legality;

@end