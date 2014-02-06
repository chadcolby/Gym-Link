//
//  BMWSignInViewController.h
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BMWSignInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

- (IBAction)signInPushed:(id)sender;

@end
