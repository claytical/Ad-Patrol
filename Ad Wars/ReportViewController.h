//
//  ReportViewController.h
//  Ad Wars
//
//  Created by Clay Ewing on 1/25/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *chiefImage;
@property (strong, nonatomic) IBOutlet UIImageView *achievementBadgeImage;
@property (strong, nonatomic) IBOutlet UILabel *achievementTextBubble;
@property (strong, nonatomic) IBOutlet UILabel *achievementLabel;
@property (strong, nonatomic) IBOutlet UIImageView *achievementBubble;
@property (strong, nonatomic) IBOutlet UILabel *achievementHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsAwarded;
@property (strong, nonatomic) NSNumber *points;
@property (nonatomic) BOOL achievementEarned;
@property (strong, nonatomic) NSString *achievementString;
@end
