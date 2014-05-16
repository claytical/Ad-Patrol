//
//  AppDelegate.h
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



// Preferred method for testing for Game Center

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
// CLLocationManager *locationManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *inventory;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) NSMutableArray *ads;
//@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (retain,readwrite) NSString * currentPlayerID;


-(void) getAds:(CLLocationCoordinate2D)location;
-(void) setCredentials;
-(void) getInventory;
-(void) getLeaderboard;
-(void) reportScore:(int)score withCategory:(NSString*)category;
-(void) checkReporterAchievement:(int)adsFound;
-(void) checkVerifiedAchievement:(int)adsVerified;
-(void) annoying;
-(void) pointsOnTheBoard;
    
@end
