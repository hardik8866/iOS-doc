//
//  PanViewController.h
//  GesturesDemo
//
//  Created by Gabriel Theodoropoulos on 8/22/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *testView;

@property (weak, nonatomic) IBOutlet UILabel *horizontalVelocityLabel;

@property (weak, nonatomic) IBOutlet UILabel *verticalVelocityLabel;

@end
