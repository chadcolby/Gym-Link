//
//  BMWSignInViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWSignInViewController.h"

@interface BMWSignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation BMWSignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.userName = [NSString new];
    self.password = [NSString new];
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    
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
            [self.passwordField resignFirstResponder];
        }
    
    return YES;
}

- (IBAction)signInPushed:(id)sender {
    
    self.userName = [self.userNameField.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [self.passwordField.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.userName length] == 0 || [self.password length] == 0 ) {
        [self showLoginError];
    } else {
        [self tryLogin];
        [self.passwordField resignFirstResponder];
    }
}

#pragma mark - Parse Methods

- (void)tryLogin
{
    [PFUser logInWithUsernameInBackground:self.userName password:self.password block:^(PFUser *user, NSError *error) {
        if (error) {
            [self showLoginError];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Alert Views

- (void)showLoginError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something Went Wrong." message: nil delegate:self cancelButtonTitle:@"Try again." otherButtonTitles: nil];
    
    [alert show];
}

@end
