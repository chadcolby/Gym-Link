//
//  BMWEventsDataSource.m
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import "BMWEventsDataSource.h"
#import <Parse/Parse.h>

#define PF_CLASS_NAME @"newEvents"

@implementation BMWEventsDataSource

- (id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryLatestEvents:) name:@"refreshRequested" object:nil];
    
    
    return self;
}

+ (BMWEventsDataSource *)sharedDataSource
{
    static dispatch_once_t pred;
    static BMWEventsDataSource *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[BMWEventsDataSource alloc] init];
    });
    
    return shared;
}

#pragma mark - Parse query 

/*
 This method is called by table view when it recieves the notification from 'pull to refresh'
*/
- (void)queryLatestEvents:(NSNotification *)notification
{
    NSLog(@"LOGGED: %@", [notification name]);
    self.queryArray = [NSArray new];
    
    PFQuery *queryNewestEvents = [PFQuery queryWithClassName:@"newEvent"];
    queryNewestEvents.limit = 6;
    [queryNewestEvents findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!objects) {
            NSLog(@"Error");
        } else {
            NSLog(@"count:%lu", objects.count);
            self.queryArray = objects;
            NSLog(@"array: %@", self.queryArray);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshComplete" object:self];
    }];

}

- (NSArray *)sortQueryResultsByDayOfWeek
{
    NSSortDescriptor *dayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"onDay" ascending:YES];
    NSArray *sortedDescriptors = @[dayDescriptor];
    
    return sortedDescriptors;
}

#pragma mark - Table view Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Upcoming Events";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.queryArray count] == 0) {
        return 1;
    } else {
        return [self.queryArray count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!self.queryArray) {
        
        cell.textLabel.text = @"Needs Refreshing.";
        cell.detailTextLabel.text = @"";

    } else {
        
        PFObject *event = [self.queryArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [event objectForKey:@"eventTitle"];
        cell.detailTextLabel.text = [event objectForKey:@"onDay"];
        cell.textLabel.textColor = [UIColor redColor];

        }

    return cell;
}


@end
