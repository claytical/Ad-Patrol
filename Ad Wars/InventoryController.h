//
//  InventoryController.h
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface InventoryController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@property (strong, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UILabel *cashOnHand;
@property (strong, nonatomic) IBOutlet UILabel *billboardsClaimedLabel;
- (IBAction)showLeaderboard:(id)sender;

@end
