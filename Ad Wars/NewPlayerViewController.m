//
//  NewPlayerViewController.m
//  Ad Wars
//
//  Created by Clay Ewing on 2/20/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import "NewPlayerViewController.h"
#import "AppDelegate.h"
#import "ChiefViewController.h"

@interface NewPlayerViewController ()

@end


@implementation NewPlayerViewController
@synthesize playerNameTextfield;

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
    [playerNameTextfield becomeFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [defaults setValue:[playerNameTextfield text] forKey:@"player"];
    [defaults synchronize];
    NSLog(@"My name is %@", [playerNameTextfield text]);
    [appDelegate setCredentials];
    [self performSegueWithIdentifier:@"Welcome" sender:nil];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Chief"]) {
        ChiefViewController *chiefView = [segue destinationViewController];
        chiefView.callingChief = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
