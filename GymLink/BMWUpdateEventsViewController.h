//
//  BMWUpdateEventsViewController.h
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMWUpdateEventsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)createEventPressed:(id)sender;

@end
