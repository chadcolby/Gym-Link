//
//  BMWEventsDataSource.h
//  GymLink
//
//  Created by Chad D Colby on 2/6/14.
//  Copyright (c) 2014 Byte Meets World. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMWEventsDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) __block NSArray *queryArray;
@property (nonatomic, strong) NSString *creationDate;

+ (BMWEventsDataSource *)sharedDataSource;

@end
