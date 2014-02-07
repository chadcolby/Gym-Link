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

    self.queryArray = [NSMutableArray new];

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

- (void)queryLatestEvents
{
    PFQuery *query = [PFQuery queryWithClassName:PF_CLASS_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Got new events! %@", objects);
        } else {
            NSLog(@"Error: %@, %@", error, [error userInfo]);
        }
    }];
}



#pragma mark - Table view Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Boo";
    
    return cell;
    
}

- (void)creatRefreshControl
{
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Update."];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self.tableView action:@selector(updateEventsTable) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
}

- (void)updateEventsTable
{
    [self.refreshControl endRefreshing];
    NSLog(@"Events!");
}

@end
