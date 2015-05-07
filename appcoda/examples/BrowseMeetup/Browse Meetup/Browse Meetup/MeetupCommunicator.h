//
//  MeetupCommunicator.h
//  BrowseMeetup
//
//  Created by Simon on 31/8/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@protocol MeetupCommunicatorDelegate;

@interface MeetupCommunicator : NSObject
@property (weak, nonatomic) id<MeetupCommunicatorDelegate> delegate;

- (void)searchGroupsAtCoordinate:(CLLocationCoordinate2D)coordinate;
@end