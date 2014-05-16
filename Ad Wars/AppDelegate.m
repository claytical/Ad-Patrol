//
//  AppDelegate.m
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation AppDelegate

@synthesize inventory, ads, players;

#pragma mark -
#pragma mark Game Center Support

@synthesize currentPlayerID;


#pragma mark -
#pragma mark Game Center Support



#pragma mark -
#pragma mark Application lifecycle


- (void) getInventory {
//    if (localPlayer.playerID != nil) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/GetPlayerInventory.php?uid=%@", [defaults valueForKey:@"playerID"]]];
    
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    // 5
    [request setDelegate:self];
    [request setTimeOutSeconds:60];

    [request setCompletionBlock:^{
        
        [self updateInventory:request.responseData];
    }];
    [request setFailedBlock:^{
        [self updateFailed];
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];

}


- (void) getLeaderboard {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/scores.php"]];
    
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    // 5
    [request setDelegate:self];
    [request setTimeOutSeconds:60];
    
    [request setCompletionBlock:^{
        
        [self updateLeaderboard:request.responseData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];
    
}



-(void) reportScore:(int)score withCategory:(NSString*)category{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/score.php"]];
    
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    
    __weak ASIFormDataRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    // 5
    [request setDelegate:self];
    [request setTimeOutSeconds:60];
    [request setPostValue:[NSNumber numberWithInt:score] forKey:@"score"];
    [request setPostValue:[defaults valueForKey:@"playerID"] forKey:@"player"];
    [request setCompletionBlock:^{
        NSLog(@"Score of %d recorded", score);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error Updating Score: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];

}

-(void) checkReporterAchievement:(int)adsFound {

    
    
}

-(void) checkVerifiedAchievement:(int)adsVerified {

}

-(void) annoying {

}

-(void) pointsOnTheBoard {
}

-(void) setCredentials {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSURL *url = [NSURL URLWithString:@"http://api.dataplayed.com/nyc/ads/CheckCredentials.php"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    // __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request setPostValue:[defaults valueForKey:@"player"] forKey:@"player"];
    [request setTimeOutSeconds:60];
    [request setCompletionBlock:^{
        NSLog(@"Response: %@", request.responseString);
        NSLog(@"Creating Player Defaults");
        
        //create account
        NSNumber *adsFound = [NSNumber numberWithInt:0];
        NSNumber *adsAmended = [NSNumber numberWithInt:0];
        NSNumber *score = [NSNumber numberWithInt:0];
     /*
        [self reportScore:0 withCategory:@"Points"];
        [self reportScore:0 withCategory:@"AdsAmended"];
        [self reportScore:0 withCategory:@"AdsFound"];
      */
        [defaults setObject:@"Yes" forKey:@"HasBeenWelcomed"];
        [defaults setObject:score forKey:@"score"];
        [defaults setObject:adsFound forKey:@"adsFound"];
        [defaults setObject:adsAmended forKey:@"adsAmended"];
        [defaults setObject:request.responseString forKey:@"playerID"];
        
        [defaults synchronize];
    }];
    [request setFailedBlock:^{
        NSLog(@"Failure on the creds");
    }];
    
    [request startAsynchronous];
}
-(void) getAds:(CLLocationCoordinate2D)location {
    NSURL *url = [NSURL URLWithString:@"http://api.dataplayed.com/nyc/ads/GetAdsNearLocation.php"];

//    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
   // __weak ASIHTTPRequest *request = _request;

    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request setPostValue:[NSNumber numberWithDouble:location.latitude] forKey:@"latitude"];
    [request setPostValue:[NSNumber numberWithDouble:location.longitude] forKey:@"longitude"];
    NSLog(@"%@?latitude=%f&longitude=%f", url, location.latitude, location.longitude);
    [request setTimeOutSeconds:60];
    [request setCompletionBlock:^{
        
        [self updateNearbyAds:request.responseData];
    }];
    [request setFailedBlock:^{
    }];
    
    [request startAsynchronous];
    


}


-(void) updateLeaderboard:(NSData*)responseData {
    [players removeAllObjects];
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    //NSLog(@"Response Data: %@", root);
    for (NSDictionary *player in root) {
        NSString *name = [player objectForKey:@"name"];
        NSString *score = [player objectForKey:@"score"];
        NSDictionary *playerToAdd = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", score, @"score", nil];
        [players addObject:playerToAdd];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LeaderboardUpdateNotification"
     object:self];
    
}


-(void) updateInventory:(NSData*)responseData {
    [inventory removeAllObjects];
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    //NSLog(@"Response Data: %@", root);
    for (NSDictionary *ad in root) {
        NSString *ad_id = [ad objectForKey:@"id"];
        NSString *address = [ad objectForKey:@"address"];
        NSString *legal = [ad objectForKey:@"legal"];
        NSString *title = [ad objectForKey:@"company"];
        NSString *city = [ad objectForKey:@"city"];
        NSString *state = [ad objectForKey:@"state"];
        NSString *zip = [ad objectForKey:@"zip"];
        NSString *filename = [NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/uploads/%@",[ad objectForKey:@"filename"]];
        NSNumber *latitude = [ad objectForKey:@"latitude"];
        NSNumber *longitude = [ad objectForKey:@"longitude"];
        NSString *name = [ad objectForKey:@"name"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
       NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:[ad objectForKey:@"taken"]];
        NSDictionary *adToAdd = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", address, @"address", latitude, @"latitude", longitude, @"longitude", ad_id, @"sid", legal, @"legal", zip, @"zip", state, @"state", city, @"city", filename, @"filename", name, @"name", date, @"taken", nil];
        [inventory addObject:adToAdd];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"InventoryUpdateNotification"
     object:self];
    
}

-(void) updateFailed {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"InventoryUpdateFailureNotification"
     object:self];
    
}
-(void) updateNearbyAds:(NSData*)responseData {
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    for (NSDictionary *ad in root) {
        NSString *address = [ad objectForKey:@"address"];
        NSString *title = address;
        NSString *pid = [ad objectForKey:@"id"];
        NSString *legal = [ad objectForKey:@"legal"];
        NSNumber *latitude = [ad objectForKey:@"latitude"];
        NSNumber *longitude = [ad objectForKey:@"longitude"];
        NSString *filename = [ad objectForKey:@"filename"];
        NSString *taken = [ad objectForKey:@"taken"];
        NSString *owner = [ad objectForKey:@"name"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        NSDictionary *adToAdd = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", address, @"address", latitude, @"latitude", longitude, @"longitude", pid, @"sid", legal, @"legal", filename, @"filename", owner, @"owner", taken, @"taken", nil];
        [ads addObject:adToAdd];
    }

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"AdUpdateNotification"
     object:self];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    ads = [[NSMutableArray alloc] init];
    inventory = [[NSMutableArray alloc] init];
    players = [[NSMutableArray alloc] init];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"alert view delegate");
}

 
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
