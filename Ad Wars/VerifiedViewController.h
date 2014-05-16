//
//  VerifiedViewController.h
//  Ad Wars
//
//  Created by Clay Ewing on 1/25/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifiedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *achievementHeaderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *badgeIconImage;
@property (strong, nonatomic) IBOutlet UILabel *achievementText;
@property (strong, nonatomic) IBOutlet UIImageView *achievementBubble;
@property (strong, nonatomic) IBOutlet UIImageView *chiefImage;
@property (strong, nonatomic) IBOutlet UILabel *verifiedPoints;
@property (nonatomic) int points;
@property (strong, nonatomic) NSString *achievementString;
@property (nonatomic) BOOL achievementEarned;

@end
