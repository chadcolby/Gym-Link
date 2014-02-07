//
//  BMWHomeViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWHomeViewController.h"

@interface BMWHomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) UITableViewController *tableViewController;

@end

@implementation BMWHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventsTableView.delegate = self;
    self.eventsTableDataSource = [BMWEventsDataSource sharedDataSource];
    self.eventsTableDataSource.tableView = self.eventsTableView;
    self.eventsTableView.dataSource = self.eventsTableDataSource;
    
    
    [self checkCurrentUser];
    self.navigationItem.hidesBackButton = YES;
    self.userPicture.backgroundColor = [UIColor blackColor];
    
    self.tableViewController = [UITableViewController new];
    self.tableViewController.tableView = self.eventsTableView;
    [self addChildViewController:self.tableViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryFinished:) name:@"refreshComplete" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createRefreshControl];

}

- (void)checkCurrentUser
{
    self.currentUser = [PFUser currentUser];
    if (self.currentUser) {
        NSLog(@"Current User: %@", self.currentUser.username);
    } else {
        [self performSegueWithIdentifier:@"pushToSignIn" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - IBActions

- (IBAction)signOutPushed:(id)sender {
    [self performSegueWithIdentifier:@"pushToSignIn" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushToSignIn"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (void)createRefreshControl
{
    self.tableViewController.refreshControl = [UIRefreshControl new];
    [self.tableViewController.refreshControl addTarget:self action:@selector(updateEventsTable) forControlEvents:UIControlEventValueChanged];
    
}

- (void)updateEventsTable
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRequested" object:self];
    
}

- (void)queryFinished:(NSNotification *)notification
{
    NSLog(@"This is what was returned: %@", [notification name]);
    [self.tableViewController.refreshControl endRefreshing];
    [self.tableViewController.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *event = [self.eventsTableDataSource.self.queryArray objectAtIndex:indexPath.row];
    NSString *detailsString = [[NSString alloc] initWithString:[event objectForKey:@"detailsKey"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Details" message:detailsString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
    
}

@end
