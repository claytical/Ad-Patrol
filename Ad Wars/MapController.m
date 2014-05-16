//
//  MapController.m
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import "MapController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SBJson.h"

#define METERS_PER_MILE 1609.344

@interface MapController ()

@end

@implementation MapController
@synthesize _mapView;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"MKannotation!");
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
 
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
 
        annotationView.pinColor = MKPinAnnotationColorGreen;
        //annotationView.image = [UIImage imageNamed:@"gold-pin.png"];//here we use a nice image instead of the default pins
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
 
    return annotationView;
    }
        return nil;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ExistingClaim"]) {
        existingClaim = [segue destinationViewController];
        existingClaim.infoURL = lookupURL;
        existingClaim.adId = ad_id;
        existingClaim.legal = legal;
        NSLog(@"URL:%@", lookupURL);
    }
        
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //add nid to url

    NSString *sid = ((MyLocation*)view.annotation).sid;
    
    legal = ((MyLocation*)view.annotation).legality;
    NSString *appended;
    if ([legal isEqualToString:@"Permitted"]) {
        appended = [NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/getById.php?pid=%@", sid];
        
    }
    else {
        appended = [NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/getById.php?fid=%@", sid];
        
    }

    lookupURL = [NSURL URLWithString:appended];
    ad_id = [NSNumber numberWithInt:[sid intValue]];
    [self performSegueWithIdentifier:@"ExistingClaim" sender:self];
    
}




- (void) updateMap:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"AdUpdateNotification"]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (id<MKAnnotation> annotation in _mapView.annotations) {
            [_mapView removeAnnotation:annotation];
        }
        
        CLLocationCoordinate2D lastCoordinate;
        for (id obj in appDelegate.ads) {
            NSNumber *lat = [obj objectForKey:@"latitude"];
            NSNumber *lon = [obj objectForKey:@"longitude"];
            CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            NSString *pid = [obj objectForKey:@"sid"];
            NSString *legality = [obj objectForKey:@"legal"];
            NSString *address = [NSString stringWithFormat:@"Last claimed by %@", [obj objectForKey:@"owner"] ];
            NSString *title = [obj  objectForKey:@"address"];
            lastCoordinate = coords;
            
            MyLocation *annotation = [[MyLocation alloc] initWithName:title address:address coordinates:coords sid:pid legality:legality];
            
            [_mapView addAnnotation:annotation];
            //check current area vs. selected area
        }
        [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
//        [_mapView setCenterCoordinate:lastCoordinate animated:YES];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, .1*METERS_PER_MILE, .1*METERS_PER_MILE);
        
        // 3
        [_mapView setRegion:viewRegion animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   }
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation      {
    CLLocationAccuracy accuracy = userLocation.location.horizontalAccuracy;
  //  if (accuracy ......) {
   // }

}
-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMap:)
                                                 name:@"AdUpdateNotification"
                                               object:nil];
   


    [self checkForLocation];
}

-(void)checkForLocation {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (CLLocationCoordinate2DIsValid(_mapView.userLocation.location.coordinate) && _mapView.userLocation.coordinate.latitude != 0 && _mapView.userLocation.coordinate.longitude != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Finding Existing Ads Nearby";
        [appDelegate getAds:_mapView.userLocation.location.coordinate];
        NSLog(@"Lat: %f, Lon: %f", _mapView.userLocation.location.coordinate.latitude, _mapView.userLocation.location.coordinate.longitude);
    }
    else {
        [self performSelector:@selector(checkForLocation) withObject:nil afterDelay:2.0];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
