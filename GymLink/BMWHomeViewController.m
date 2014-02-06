//
//  BMWHomeViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWHomeViewController.h"

@interface BMWHomeViewController ()

@end

@implementation BMWHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkCurrentUser];
    self.view.backgroundColor = [UIColor blueColor];
    self.navigationItem.hidesBackButton = YES;
    
    
}

- (void)checkCurrentUser
{
    self.currentUser = [PFUser currentUser];
    if (self.currentUser) {
        NSLog(@"Current User: %@", self.currentUser);
    } else {
        [self performSegueWithIdentifier:@"pushToSignIn" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushToSignIn"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
