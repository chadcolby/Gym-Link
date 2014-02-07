//
//  BMWHomeViewController.h
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BMWEventsDataSource.h"

@interface BMWHomeViewController : UIViewController <UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, weak) BMWEventsDataSource *eventsTableDataSource;

- (IBAction)signOutPushed:(id)sender;


@end
