//
//  VerifiedViewController.m
//  Ad Wars
//
//  Created by Clay Ewing on 1/25/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import "VerifiedViewController.h"

@interface VerifiedViewController ()

@end

@implementation VerifiedViewController
@synthesize verifiedPoints, points, achievementString, achievementEarned, chiefImage, achievementBubble, achievementText, badgeIconImage, achievementHeaderLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [verifiedPoints setText:[NSString stringWithFormat:@"+%d points",points]];
    [self performSelector:@selector(removeScreen) withObject:nil afterDelay:3.0];
    if (achievementEarned) {
        [achievementText setText:achievementString];
        [achievementText setHidden:NO];
        [badgeIconImage setHidden:NO];
        [achievementHeaderLabel setHidden:NO];
        [achievementBubble setHidden:NO];
        [chiefImage setHidden:NO];
    }
    else {
        [achievementText setHidden:YES];
        [badgeIconImage setHidden:YES];
        [achievementHeaderLabel setHidden:YES];
        [achievementBubble setHidden:YES];
        [chiefImage setHidden:YES];
    }
}
-(void) removeScreen {
    NSLog(@"Attempting to remove screen");
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
