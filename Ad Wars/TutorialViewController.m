//
//  TutorialViewController.m
//  Ad Wars
//
//  Created by Clay Ewing on 2/4/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController
@synthesize webViewStory, webViewReporting, webViewVerifying;
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

-(void) viewWillAppear:(BOOL)animated {
    
    NSString *fullURL = @"http://api.dataplayed.com/nyc/ads/story.html";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webViewStory loadRequest:requestObj];
    fullURL = @"http://api.dataplayed.com/nyc/ads/reporting.html";
    url = [NSURL URLWithString:fullURL];
    requestObj = [NSURLRequest requestWithURL:url];
    [webViewReporting loadRequest:requestObj];
    fullURL = @"http://api.dataplayed.com/nyc/ads/verifying.html";
    url = [NSURL URLWithString:fullURL];
    requestObj = [NSURLRequest requestWithURL:url];
    [webViewVerifying loadRequest:requestObj];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
	return NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

@end
