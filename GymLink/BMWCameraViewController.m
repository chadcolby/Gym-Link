//
//  BMWCameraViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/7/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWCameraViewController.h"
#import "BMWHomeViewController.h"
#import <Parse/Parse.h>

@interface BMWCameraViewController ()


@property (strong, nonatomic) BMWHomeViewController *homeViewController;

@end

@implementation BMWCameraViewController

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
    self.homeViewController = [[BMWHomeViewController alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - IBActions

- (IBAction)cameraPushed:(id)sender {
    NSLog(@"They want a picture!");
    UIActionSheet *cameraActions = [[UIActionSheet alloc] initWithTitle:@"Set New Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    [cameraActions showFromBarButtonItem:sender animated:YES];
    
}

- (IBAction)useButtonPushed:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pictureUpdated" object:self];

    
    [self.view removeFromSuperview];
    
    
}

#pragma mark - Action Sheet Delegate Stuff

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Camera"]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Photo Library"]) {
        UIImagePickerController *imagePickerLibrary = [[UIImagePickerController alloc]init];
        imagePickerLibrary.delegate = self;
        
        imagePickerLibrary.allowsEditing = YES;
        imagePickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerLibrary animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.imageTaken.image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.imageTaken.layer.masksToBounds = YES;
        self.imageTaken.layer.cornerRadius = self.imageTaken.layer.bounds.size.width / 2;
        
        self.picData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//        NSString *documentPath = [paths objectAtIndex:0];
//        NSString *currentUsername = [NSString stringWithFormat:@"%@.png", self.navigationItem.title];
//        //NSString *filePath = [documentPath stringByAppendingString:currentUsername];
//        NSLog(@"filepath: %@", self.homeViewController.currentUser);
//        
//        NSData *PNGData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
//        [PNGData writeToFile:filePath atomically:YES];
//        [NSKeyedArchiver archiveRootObject:PNGData toFile:@""];
//        NSLog(@"Data here: %@", PNGData);
    }];
}

@end
