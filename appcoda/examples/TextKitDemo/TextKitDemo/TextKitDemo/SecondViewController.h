//
//  SecondViewController.h
//  TextKitDemo
//
//  Created by Gabriel Theodoropoulos on 21/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)makeBold:(id)sender;
- (IBAction)makeItalic:(id)sender;
- (IBAction)underlineText:(id)sender;
- (IBAction)alignTextLeft:(id)sender;
- (IBAction)centerText:(id)sender;
- (IBAction)alignTextRight:(id)sender;
- (IBAction)makeTextColorRed:(id)sender;
- (IBAction)makeTextColorBlack:(id)sender;

@end
