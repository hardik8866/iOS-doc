//
//  ViewController.h
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestViewController.h"

@interface ViewController : UIViewController <UIActionSheetDelegate, TestViewControllerDelegate>

- (IBAction)showNormalActionSheet:(id)sender;

- (IBAction)showDeleteConfirmation:(id)sender;

- (IBAction)showColorsActionSheet:(id)sender;

- (IBAction)showUserDataEntryForm:(id)sender;

@end
