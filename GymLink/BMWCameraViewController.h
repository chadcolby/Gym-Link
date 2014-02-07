//
//  BMWCameraViewController.h
//  GymLink
//
//  Created by Chad D Colby on 2/7/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMWCameraViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageTaken;
@property (strong, nonatomic) NSData *picData;

- (IBAction)cameraPushed:(id)sender;
- (IBAction)useButtonPushed:(id)sender;


@end
