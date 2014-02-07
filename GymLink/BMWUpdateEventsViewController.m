//
//  BMWUpdateEventsViewController.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWUpdateEventsViewController.h"
#import <Parse/Parse.h>

#define TITLE_KEY @"eventTitle"
#define ON_DAY_KEY @"onDay"
#define DETAILS_KEY @"detailsKey"
#define PF_CLASS_NAME @"newEvents"

@interface BMWUpdateEventsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventTitleField;
@property (weak, nonatomic) IBOutlet UITextField *onDayField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;

@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *onDay;
@property (strong, nonatomic) NSString *details;

@property (strong, nonatomic) NSMutableDictionary *singleEventDictionary;

@property (strong, nonatomic) PFObject *freshEvent;
@property (strong, nonatomic) NSMutableArray *arrayOfEvents;

@end

@implementation BMWUpdateEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventTitle =[NSString new];
    self.onDay =[NSString new];
    self.details =[NSString new];
    
    self.eventTitleField.delegate = self;
    self.onDayField.delegate = self;
    self.detailsField.delegate = self;
    
    [self.eventTitleField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.eventTitleField) {
        [self.onDayField becomeFirstResponder];
    } else {
        [self.detailsField becomeFirstResponder];
        self.detailsField.text = @"";
        }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.detailsField.text = @"";
}

#pragma mark - IBActions

/*
 used to capture user input
*/
- (IBAction)doneButtonPressed:(id)sender
{
    self.eventTitle = self.eventTitleField.text;
    self.onDay = self.onDayField.text;
    self.details = self.detailsField.text;
    
    [self.detailsField resignFirstResponder];
}

/*
 used to store user input in event dictionary
*/
- (IBAction)createEventPressed:(id)sender
{
    UIActionSheet *optionsSheet = [[UIActionSheet alloc] initWithTitle:@"You can..." delegate:self cancelButtonTitle:@"Canel" destructiveButtonTitle:nil otherButtonTitles:@"Add another", @"Finish", nil];
    
    [optionsSheet showInView:self.view];
    
    // Create new PFObject for entered event
    self.freshEvent = [PFObject objectWithClassName:@"newEvent"];
    [self.freshEvent setObject:self.eventTitle forKey:TITLE_KEY];
    [self.freshEvent setObject:self.onDay forKey:ON_DAY_KEY];
    [self.freshEvent setObject:self.details forKey:DETAILS_KEY];
    
//    self.singleEventDictionary = [NSMutableDictionary new];
//    [self.singleEventDictionary setObject:self.eventTitle forKey:TITLE_KEY];
//    [self.singleEventDictionary setObject:self.onDay forKey:ON_DAY_KEY];
//    [self.singleEventDictionary setObject:self.details forKey:DETAILS_KEY];
    
    NSLog(@"Event: %@", self.freshEvent);
    
    if (!self.arrayOfEvents) {
        self.arrayOfEvents = [NSMutableArray new];
    }
    
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add another"]) {
        
        [self.arrayOfEvents addObject:self.freshEvent]; // Update array containing events
        
        self.eventTitleField.text = @"";
        self.onDayField.text = @"";
        self.detailsField.text = @"Add Details";
        
        [self.eventTitleField becomeFirstResponder];
        
        NSLog(@"Add another %lu", (unsigned long)self.arrayOfEvents.count);

    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Finish"]) {
        
        [self.arrayOfEvents addObject:self.freshEvent];
        
        PFObject *packagedEvents = [PFObject objectWithClassName:PF_CLASS_NAME];
        packagedEvents[@"eventsArray"] = self.arrayOfEvents; //Package array of added events into single PFObject
        [packagedEvents saveInBackground];
        
        NSLog(@"results: %@", self.arrayOfEvents);
        
        NSLog(@"Finish.");
        
    }
}

@end
