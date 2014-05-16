//
//  TopPlayersViewController.h
//  Ad Wars
//
//  Created by Clay Ewing on 2/20/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TopPlayersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *appDelegate;

}
- (IBAction)backToInventory:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;

@end
