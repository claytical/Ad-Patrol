//
//  ClaimController.m
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import "ClaimController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "ReportViewController.h"

@interface ClaimController ()
@end

@implementation ClaimController
@synthesize _claimMap, addressTextField, companyTextField, cameraImageView, claimButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    NSLog(@"Updating Location");
    mapRegion.span.latitudeDelta = .005;
    mapRegion.span.longitudeDelta = .005;
    [mapView setRegion:mapRegion animated: YES];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    currentLocation = [[CLLocation alloc] initWithLatitude:_claimMap.userLocation.coordinate.latitude longitude:_claimMap.userLocation.coordinate.longitude];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (!didClearAddress) {
            NSString *addy = [placemark subThoroughfare];
            NSString *street = [placemark thoroughfare];
            if (addy.length == 0) {
                addy = @"";
            }
            if (street.length == 0) {
                street = @"";
            }
            [addressTextField setText:[NSString stringWithFormat:@"%@ %@", addy, street]];
            city = [placemark locality];
            state = [placemark administrativeArea];
            zipcode = [placemark postalCode];
        }
            //        NSLog(@"Placemark: %@ %@, %@, %@", , [placemark locality], [placemark postalCode]);
        
    }];
    [mapView setShowsUserLocation:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    ClaimController *claim = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraOverlay"];
    MKCoordinateRegion mapRegion;
    mapRegion.center = _claimMap.userLocation.coordinate;
    mapRegion.span.latitudeDelta = .005;
    mapRegion.span.longitudeDelta = .005;
    didClearAddress = NO;
    [_claimMap setRegion:mapRegion animated: YES];
    [companyTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)claimButtonPressed:(id)sender {
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *address = [addressTextField text];
    NSString *company = [companyTextField text];

    NSString *latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
  
    NSData *imageData = UIImageJPEGRepresentation(adImage, 90);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dataplayed.com/nyc/ads/SubmitAd.php"]];
    
    // Now, we have to find the documents directory so we can save it
    // Note that you might want to save it elsewhere, like the cache directory, or something similar.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"photo.jpg"];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    // Upload an NSData instance
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:60];
    [request setFile:fullPathToFile forKey:@"photo"];
    [request setPostValue:latitude forKey:@"latitude"];
    [request setPostValue:longitude forKey:@"longitude"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:company forKey:@"company"];
    [request setPostValue:city forKey:@"city"];
    [request setPostValue:zipcode forKey:@"zip"];
    [request setPostValue:state forKey:@"state"];
    //player id
    [request setPostValue:[defaults valueForKey:@"playerID"] forKey:@"pid"];
    NSLog(@"Submitting ad for player %@", [defaults valueForKey:@"playerID"]);
    //check if passedData is nil
    if (imageData == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Photo Needed" message:@"In order to claim this spot, you need to take a picture of it." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Reporting Ad";
        
        [request setDelegate:self];
        [request startAsynchronous];
        
    }
    

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Reported"]) {
        NSLog(@"Reported Segue");
        ReportViewController *reportController = [segue destinationViewController];
        [reportController setPoints:[NSNumber numberWithInt:2]];
        if (achievementEarned) {
            reportController.achievementString = achievementString;
            reportController.achievementEarned = YES;
        }
    }
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    // Use when fetching text data
    NSString *responseString = [request responseString];
    if ([responseString isEqualToString:@"Already Exists"]) {
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Previously Claimed" message:@"Someone already found this ad, maybe you should steal it from them instead." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];



    }
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber * adRate = [f numberFromString:responseString];
        int newCashOnHand = [adRate intValue] + [[defaults valueForKey:@"money"] intValue];
        [defaults setObject:[NSNumber numberWithInt:newCashOnHand] forKey:@"money"];
        int postedAlready = [[defaults objectForKey:@"billboardsPosted"] intValue];
        [defaults setObject:[NSNumber numberWithInt:postedAlready+1] forKey:@"billboardsClaimed"];
        int points = 2;
        BOOL firstScore = NO;
        if ([[defaults valueForKey:@"score"] intValue] == 0) {
            //first points scored
            firstScore = YES;
        }

        int newScore = [[defaults objectForKey:@"score"] intValue] + points;
        NSLog(@"New Score: %d, Old Score: %d", newScore, [[defaults objectForKey:@"score"] intValue]);
        int newFound = [[defaults objectForKey:@"adsFound"] intValue] + 1;
        [defaults setObject:[NSNumber numberWithInt:newScore] forKey:@"score"];
        [defaults setObject:[NSNumber numberWithInt:newFound] forKey:@"adsFound"];
        [defaults synchronize];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate reportScore:newScore withCategory:@"Points"];
        //[appDelegate reportScore:newFound withCategory:@"AdsFound"];
        [appDelegate checkReporterAchievement:newFound];
        switch (newFound) {
            case 10:
                achievementEarned = YES;
                achievementString = @"Junior Reporter achieved";
                break;
            case 25:
                achievementEarned = YES;
                achievementString = @"Reporter achieved";
                break;
            case 50:
                achievementEarned = YES;
                achievementString = @"Senior Reporter achieved";
                break;
            case 100:
                achievementEarned = YES;
                achievementString = @"Super Reporter achieved";

            default:
                break;
        }
        if (firstScore) {
            //first points scored
            [appDelegate pointsOnTheBoard];
            achievementEarned = YES;
            achievementString = @"Points on the Board achieved.";
            
        }

        [self performSegueWithIdentifier:@"Reported" sender:self];

    }
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Woops" message:[NSString stringWithFormat:@"There was a problem submitting this ad, try it again!"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    
}

- (IBAction)changedAddress:(id)sender {
    didClearAddress = YES;
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = (id)self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.allowsEditing = YES;
   [self presentViewController:imagePicker animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *img = [[self class] imageWithImage:image scaledToSize:CGSizeMake(120, 80)];
    cameraImageView.image = img;
    adImage = image;

}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    [self claimButtonPressed:nil];
    return YES;
}
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

