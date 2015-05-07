//
//  FirstViewController.h
//  TextKitDemo
//
//  Created by Gabriel Theodoropoulos on 21/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)applyHeadlineStyle:(id)sender;
- (IBAction)applySubHeadlineStyle:(id)sender;
- (IBAction)applyBodyStyle:(id)sender;
- (IBAction)applyFootnoteStyle:(id)sender;
- (IBAction)applyCaption1Style:(id)sender;
- (IBAction)applyCaption2Style:(id)sender;
- (IBAction)toggleImage:(id)sender;

@end
