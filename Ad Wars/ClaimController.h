//
//  ClaimController.h
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface ClaimController : UIViewController <MKMapViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {
    CLLocation *currentLocation;
    BOOL didClearAddress;
    UIImage *adImage;
    NSString *city;
    NSString *state;
    NSString *zipcode;
    NSString *achievementString;
    BOOL achievementEarned;
}

- (IBAction)claimButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (strong, nonatomic) IBOutlet UIButton *claimButton;
@property (weak, nonatomic) IBOutlet MKMapView *_claimMap;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTextField;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (IBAction)changedAddress:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
