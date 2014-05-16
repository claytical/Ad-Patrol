//
//  InventoryController.m
//  Ad Wars
//
//  Created by Clay Ewing on 12/4/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import "InventoryController.h"
#import "ExistingClaimController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ChiefViewController.h"

@implementation InventoryController
@synthesize _tableView, playerLabel, cashOnHand, billboardsClaimedLabel, reportButton;


- (void) updateInventory:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"InventoryUpdateNotification"]) {
        [reportButton setEnabled:YES];
        [_tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
    if ([[notification name] isEqualToString:@"InventoryUpdateFailureNotification"]) {
        [reportButton setEnabled:YES];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    if ([[notification name] isEqualToString:@"InventoryNoPlayerId"]) {
//check if player now exists, might not be needed
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if ([defaults valueForKey:@"playerID"]) {
            [playerLabel setText:[defaults valueForKey:@"player"]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Updating Inventory";
        }
        [appDelegate performSelector:@selector(getInventory) withObject:nil afterDelay:2.0];

    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"InventorySelection"]) {
        ExistingClaimController *existingClaim = [segue destinationViewController];

        existingClaim.address = [[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"address"];
        existingClaim.claim = [[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"taken"];
        existingClaim.owner = [[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"name"];
        existingClaim.filename = [[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"filename"];
        
        existingClaim.latitude = [[[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"latitude"] doubleValue];
        existingClaim.longitude = [[[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"longitude"] doubleValue];
        existingClaim.legal = [[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"legal"];
        existingClaim.adId = [[appDelegate.inventory objectAtIndex:_tableView.indexPathForSelectedRow.row] objectForKey:@"sid"];
    }

    if ([[segue identifier] isEqualToString:@"Chief"]) {
        ChiefViewController *chiefView = [segue destinationViewController];
        chiefView.callingChief = NO;
        NSLog(@"Chief Segue Happening");
    }
    if ([[segue identifier] isEqualToString:@"CallChief"]) {
        ChiefViewController *chiefView = [segue destinationViewController];
        chiefView.callingChief = YES;
        //if not connected
//            chiefView.noPlayerID = YES;
        NSLog(@"Chief Call Segue Happening");

    }
    
}

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
    [self.navigationController setNavigationBarHidden:YES];
	// Do any additional setup after loading the view.
    //Check if current location has an ad or not, set button to activate it
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //check if authenticated
    if ([defaults valueForKey:@"playerID"]) {
        [reportButton setEnabled:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Updating Inventory";
    }
    else {
        [reportButton setEnabled:NO];
    }
    
}


- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
}

- (void) viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults valueForKey:@"playerID"]) {
        //get their name and set them up
        [playerLabel setText:@"Not Connected"];
        [self.navigationController performSegueWithIdentifier:@"Chief" sender:self];
        [defaults setValue:@"Yes" forKey:@"HasBeenWelcomed"];
        [defaults synchronize];

    }
    else {
        
        [playerLabel setText:[defaults valueForKey:@"player"]];

    }
    
    [cashOnHand setText:[NSString stringWithFormat:@"%@ points", [[defaults valueForKey:@"score"] stringValue]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInventory:)
                                                 name:@"InventoryUpdateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInventory:)
                                                 name:@"InventoryNoPlayerId"
                                               object:nil];
    [appDelegate getInventory];
    NSLog(@"Score: %@, Amends: %@", [defaults valueForKey:@"score"], [defaults valueForKey:@"adsAmended"]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //if authenticated
    if (appDelegate != nil) {
        return [appDelegate.inventory count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //if authenticated with player id
    if (appDelegate != nil) {
    // Configure the cell...
        if ([appDelegate.inventory count] != 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            cell.textLabel.text = [[appDelegate.inventory objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.detailTextLabel.text = [[appDelegate.inventory objectAtIndex:indexPath.row] objectForKey:@"address"];
            [cell.imageView setImageWithURL:[[appDelegate.inventory objectAtIndex:indexPath.row] objectForKey:@"filename"] placeholderImage:[UIImage imageNamed:@"first.png"]];
        }
        else {
            cell.textLabel.text = @"No ads reported";
            cell.detailTextLabel.text = @"";
            [cell.imageView setImage:nil];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
    }
    else {
        cell.textLabel.text = @"Retrieving records";
        cell.detailTextLabel.text = @"";
        [cell.imageView setImage:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)showLeaderboard:(id)sender {

}

@end
