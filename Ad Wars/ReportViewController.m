//
//  ReportViewController.m
//  Ad Wars
//
//  Created by Clay Ewing on 1/25/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import "ReportViewController.h"
@interface ReportViewController ()

@end

@implementation ReportViewController
@synthesize pointsAwarded, points, achievementEarned, achievementHeaderLabel, achievementString, chiefImage, achievementBadgeImage, achievementLabel, achievementTextBubble, achievementBubble;

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

- (void) viewWillAppear:(BOOL)animated {
    [pointsAwarded setText:[NSString stringWithFormat:@"+%@ points",points]];
    /*if (achievementEarned) {
        [achievementLabel setText:achievementString];
        [achievementTextBubble setHidden:NO];
        [achievementBadgeImage setHidden:NO];
        [achievementHeaderLabel setHidden:NO];
        [achievementBubble setHidden:NO];
        [achievementLabel setHidden:NO];
        [chiefImage setHidden:NO];
    }

    else {
*/
        [achievementBubble setHidden:YES];
        [achievementTextBubble setHidden:YES];
        [achievementBadgeImage setHidden:YES];
        [achievementHeaderLabel setHidden:YES];
        [achievementLabel setHidden:YES];
        [chiefImage setHidden:YES];
        
//    }
    [self performSelector:@selector(removeScreen) withObject:nil afterDelay:3.0];

}
-(void) removeScreen {

        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
