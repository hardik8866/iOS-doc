//
//  MeetupManager.h
//  BrowseMeetup
//
//  Created by Simon on 31/8/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MeetupManagerDelegate.h"
#import "MeetupCommunicatorDelegate.h"

@class MeetupCommunicator;

@interface MeetupManager : NSObject<MeetupCommunicatorDelegate>
@property (strong, nonatomic) MeetupCommunicator *communicator;
@property (weak, nonatomic) id<MeetupManagerDelegate> delegate;

- (void)fetchGroupsAtCoordinate:(CLLocationCoordinate2D)coordinate;
@end