//
//  ExistingClaimController.m
//  Ad Wars
//
//  Created by Clay Ewing on 12/10/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import "ExistingClaimController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "VerifiedViewController.h"

@interface ExistingClaimController ()

@end

@implementation ExistingClaimController
@synthesize adImage, adThumbImage, latitude, longitude, ownerLabel, claimLabel, addressLabel, address, claim, owner, _mapView, filename;
@synthesize infoURL, claimButton, updatedImage, adId, legal, cameraButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setExistingClaim {
    [addressLabel setText:address];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd MM yyyy"];       //Remove the time part
    NSString *TodayString = [df stringFromDate:[NSDate date]];
    NSString *TargetDateString = [df stringFromDate:claim];
    NSTimeInterval time = [[df dateFromString:TodayString] timeIntervalSinceDate:[df dateFromString:TargetDateString]];
    int hours = time / 60 / 60;
    days = time / 60 / 60/ 24;
//    NSLog(@"CLAIM: %@ Today: %@ Target: %@", claim, TodayString, TargetDateString);
    [ownerLabel setText:[NSString stringWithFormat:@"Last claimed by %@ %d days ago", owner, days]];
    [adImage setImageWithURL:[NSURL URLWithString:filename]];
    if (hours > 23) {
        [claimButton setEnabled:YES];
        [cameraButton setEnabled:YES];
    }
    else {
        [claimButton setEnabled:NO];
        [cameraButton setEnabled:NO];
    }
    [self performSelector:@selector(zoomToLocation:) withObject:nil afterDelay:0.01];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!infoURL) {

        [self setExistingClaim];

    }
    else {
        //lookup info for ad

        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:infoURL];
        
        __weak ASIHTTPRequest *request = _request;
        
        request.requestMethod = @"POST";
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request setDelegate:self];
        [request setTimeOutSeconds:60];
        [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *responseDict = [[request responseString] JSONValue];
        address = [responseDict valueForKey:@"address"];
        longitude = [[responseDict valueForKey:@"longitude"] doubleValue];
        latitude = [[responseDict valueForKey:@"latitude"] doubleValue];
        filename = [NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/uploads/%@",[responseDict valueForKey:@"filename"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:[responseDict valueForKey:@"taken"]];
        claim = date;
        owner = [responseDict valueForKey:@"name"];
            
        [self setExistingClaim];
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"Error: %@", error.localizedDescription);
        }];
        
        // 6
        [request startAsynchronous];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Gathering Intel";

    }
    
}

- (void)zoomToLocation:(CLLocationCoordinate2D)userLocation
{

    CLLocationDistance visibleDistance = 100; // 100 kilometers
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitude, longitude), visibleDistance, visibleDistance);
    
    [_mapView setRegion:adjustedRegion animated:YES];

}
-(void) viewWillAppear:(BOOL)animated {
   // [self performSelector:@selector(zoomToLocation:) withObject:nil afterDelay:0.01];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *img = [[self class] imageWithImage:image scaledToSize:CGSizeMake(120, 80)];
    updatedImage = image;
    adThumbImage.image = img;
    
}
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = (id)self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    

}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (IBAction)claimThisAd:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //make sure they're logged in
    if ([defaults valueForKey:@"playerID"]) {

    
    CLLocation *adLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:_mapView.userLocation.coordinate.latitude longitude:_mapView.userLocation.coordinate.longitude];
    double metersFromLocation = [adLocation distanceFromLocation:currentLocation];
        NSLog(@"Loc1: %@, Loc2: %@, You are %f from the ad", adLocation, currentLocation, metersFromLocation);
    if (metersFromLocation < 100) {
    
        NSData *imageData = UIImageJPEGRepresentation(updatedImage, 90);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/SubmitEvidence.php"]];
        
        // Now, we have to find the documents directory so we can save it
        // Note that you might want to save it elsewhere, like the cache directory, or something similar.
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        
        // Now we get the full path to the file
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"photo.jpg"];
        [imageData writeToFile:fullPathToFile atomically:NO];
        
        // Upload an NSData instance
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setFile:fullPathToFile forKey:@"photo"];
        [request setPostValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
        [request setPostValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
       //set player id
        [request setPostValue:[defaults valueForKey:@"playerID"] forKey:@"pid"];
        [request setPostValue:address forKey:@"address"];
        [request setPostValue:legal forKey:@"legal"];
        [request setTag:999];
        //id & legal
        [request setPostValue:adId forKey:@"ad_id"];
        //check if passedData is nil
        if (imageData == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We need the latest photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Verifying Ad";

        [request setDelegate:self];
        [request startAsynchronous];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get Closer" message:[NSString stringWithFormat:@"You're %f meters away.  You need to be at least 30 meters from the ad in order to verify it", metersFromLocation] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Center" message:@"You need to enable Game Center in order to report ads." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops" message:[NSString stringWithFormat:@"There was a problem submitting this ad, try it again!"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 999) {
    // Use when fetching text data
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        int points = (days * 2) + 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL firstScore = NO;
        if ([[defaults valueForKey:@"score"] intValue] == 0) {
            //first points scored
            firstScore = YES;
        }
        
        int newScore = [[defaults valueForKey:@"score"] intValue] + points;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        if ([[defaults valueForKey:@"adsAmended"] intValue] == 0) {
            //badge for first unverified report
            [appDelegate pointsOnTheBoard];

        }
        int newAmended = [[defaults valueForKey:@"adsAmended"] intValue]+ 1;
        //int newAmended = [[[defaults objectForKey:@"adsAmended"] value] intValue] + 1;
//        int newAmended = 1;
            
        [defaults setObject:[NSNumber numberWithInt:newScore] forKey:@"score"];
        [defaults setObject:[NSNumber numberWithInt:newAmended] forKey:@"adsAmended"];
        [defaults synchronize];
        [appDelegate reportScore:newScore withCategory:@"Points"];
        //[appDelegate reportScore:newAmended withCategory:@"AdsAmended"];
        [appDelegate checkVerifiedAchievement:newAmended];
        switch (newAmended) {
            case 10:
                achievementEarned = YES;
                achievementString = @"Junior Fact Checker achieved";
                break;
            case 25:
                achievementEarned = YES;
                achievementString = @"Fact Checker achieved";
                break;
            case 50:
                achievementEarned = YES;
                achievementString = @"Senior Fact Checker achieved";
                break;
            case 100:
                achievementEarned = YES;
                achievementString = @"Fact Checker of Steel achieved";
                
            default:
                break;
        }

        
        pointsEarned = points;        
        [self performSegueWithIdentifier:@"Verified" sender:self];
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Points!" message:[NSString stringWithFormat:@"You earned %d points",points] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        */
    }

}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Verified"]) {
        VerifiedViewController *verifiedController = [segue destinationViewController];
        verifiedController.points = pointsEarned;
        if (achievementEarned) {
            verifiedController.achievementString = achievementString;
            verifiedController.achievementEarned = YES;
        }

    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
