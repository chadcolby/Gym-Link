//
//  BMWNewUserViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWNewUserViewController.h"

@interface BMWNewUserViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@end

@implementation BMWNewUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userName = [NSString new];
    self.password = [NSString new];
    self.email = [NSString new];
    
    self.emailField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
    } else
        if (textField == self.passwordField) {
            [self.emailField becomeFirstResponder];
        } else
            if (textField == self.emailField) {
                [self.emailField resignFirstResponder];
            }
    return YES;
}

#pragma mark - IBActions

- (IBAction)creatAccountPushed:(id)sender {
    self.userName = [self.userNameField.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [self.passwordField.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.email = [self.emailField.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.userName length] == 0 || [self.password length] == 0 || [self.email length] == 0) {
        [self showMissingInfoAlert];
    } else {
        [self createNewUser];
    }
}

#pragma mark - Parse Methods

- (void)createNewUser
{
    PFUser *newUser = [PFUser new];
    newUser.username = self.userName;
    newUser.password = self.password;
    newUser.email = self.email;
    
    NSLog(@"Name: %@, pass: %@, email: %@", self.userName, self.password, self.email);
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self showCreateNewAllert:error];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Alert Views

- (void)showCreateNewAllert:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Our bad." message:[error.userInfo objectForKey:@"error"] delegate:self cancelButtonTitle:@"Fine." otherButtonTitles: nil];
    
    [alert show];
}

- (void)showMissingInfoAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong:" message:@"Please try again." delegate:self cancelButtonTitle:@"I'll do better this time." otherButtonTitles: nil];
    
    [alert show];
}


@end
