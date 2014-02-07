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
    
    [self.eventsTableDataSource creatRefreshControl];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.eventsTableDataSource creatRefreshControl];
    
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


@end
