//
//  BMWHomeViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWHomeViewController.h"
#import "BMWCameraViewController.h"

@interface BMWHomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (strong, nonatomic) UITableViewController *tableViewController;
@property (strong, nonatomic) BMWCameraViewController *cameraViewController;

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
    [self makeUserPictureLookGood];
    
    [self createCameraViewController];
    [self tapGestureSetup];
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
- (void)makeUserPictureLookGood
{
    self.userPicture.layer.masksToBounds = YES;
    self.userPicture.layer.cornerRadius = self.userPicture.bounds.size.width / 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Add Camera VC

- (void)createCameraViewController
{
    self.cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraVC"];
    self.cameraViewController.view.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)tapGestureSetup
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCameraController:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.userPicture addGestureRecognizer:tapGesture];
    
}

- (void)showCameraController:(UITapGestureRecognizer *)sender
{

    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self addChildViewController:self.cameraViewController];
        self.cameraViewController.view.frame = self.view.frame;
        [self.view addSubview:self.cameraViewController.view];
        [self.cameraViewController didMoveToParentViewController:self];
        NSLog(@"Double tap!");
    }
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
    if ([self.eventsTableDataSource.self.queryArray count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.userInteractionEnabled = NO;
    } else {
        PFObject *event = [self.eventsTableDataSource.self.queryArray objectAtIndex:indexPath.row];
        NSString *detailsString = [[NSString alloc] initWithString:[event objectForKey:@"detailsKey"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Details" message:detailsString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
}

@end
