//
//  MapController.h
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyLocation.h"
#import "ASIHTTPRequest.h"
#import "ExistingClaimController.h"


@interface MapController : UIViewController <MKMapViewDelegate> {

    ExistingClaimController *existingClaim;
    NSURL *lookupURL;
    NSNumber *ad_id;
    NSString *legal;
}

@property (weak, nonatomic) IBOutlet MKMapView *_mapView;

@end
