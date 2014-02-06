//
//  BMWNewUserViewController.h
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWSignInViewController.h"

@interface BMWNewUserViewController : BMWSignInViewController

@property (nonatomic, strong) NSString *email;

- (IBAction)creatAccountPushed:(id)sender;

@end
