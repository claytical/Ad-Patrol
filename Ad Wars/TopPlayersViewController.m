//
//  TopPlayersViewController.m
//  Ad Wars
//
//  Created by Clay Ewing on 2/20/13.
//  Copyright (c) 2013 Clay Ewing. All rights reserved.
//

#import "TopPlayersViewController.h"
#import "MBProgressHUD.h"


@implementation TopPlayersViewController
@synthesize _tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) updateLeaderboard:(NSNotification *) notification {
        [_tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
}


-(void) viewWillAppear:(BOOL)animated {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting Top Patrollers";

    [appDelegate getLeaderboard];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLeaderboard:)
                                                 name:@"LeaderboardUpdateNotification"
                                               object:nil];
    
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
    return [appDelegate.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([appDelegate.players count] != 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.textLabel.text = [[appDelegate.players objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text = [[appDelegate.players objectAtIndex:indexPath.row] objectForKey:@"score"];
    }
    // Configure the cell...
    
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

- (IBAction)backToInventory:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
