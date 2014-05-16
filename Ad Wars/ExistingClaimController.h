//
//  ExistingClaimController.h
//  Ad Wars
//
//  Created by Clay Ewing on 12/10/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ExistingClaimController : UIViewController <UIImagePickerControllerDelegate, UIAlertViewDelegate> {
    int days;
    int pointsEarned;
    NSString *achievementString;
    BOOL achievementEarned;

}
@property (nonatomic) NSNumber *adId;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *claimLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UIButton *claimButton;
@property (strong, nonatomic) IBOutlet MKMapView *_mapView;
@property (strong, nonatomic) IBOutlet UILabel *worthLabel;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIImageView *adImage;
@property (strong, nonatomic) IBOutlet UIImageView *adThumbImage;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *owner;
@property (nonatomic) NSDate *claim;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSURL *infoURL;
@property (nonatomic) NSString *legal;
@property (nonatomic) UIImage *updatedImage;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (IBAction)takePhoto:(id)sender;
- (IBAction)claimThisAd:(id)sender;
- (IBAction)goBack:(id)sender;

@end
