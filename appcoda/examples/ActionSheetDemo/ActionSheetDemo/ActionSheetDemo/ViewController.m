//
//  ViewController.m
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIPopoverController *userDataPopover;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)showNormalActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the file?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete it"
                                                    otherButtonTitles:@"Copy", @"Move", @"Duplicate", nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    
    actionSheet.tag = 100;
}

- (IBAction)showDeleteConfirmation:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete the selected contact?"
                                                             delegate:self
                                                    cancelButtonTitle:@"No, I changed my mind"
                                               destructiveButtonTitle:@"Yes, delete it"
                                                    otherButtonTitles:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    
    actionSheet.tag = 200;
}


- (IBAction)showColorsActionSheet:(id)sender {
    NSString *cancelTitle = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"Cancel" : nil;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a color:"
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Red", @"Green", @"Blue", @"Orange", @"Purple", nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    
    actionSheet.tag = 300;
}


- (IBAction)showUserDataEntryForm:(id)sender {
    TestViewController *testViewController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    testViewController.delegate = self;
    
    self.userDataPopover = [[UIPopoverController alloc] initWithContentViewController:testViewController];

    self.userDataPopover.popoverContentSize = CGSizeMake(320.0, 400.0);
    
    [self.userDataPopover presentPopoverFromRect:[(UIButton *)sender frame]
                                          inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:YES];
}


#pragma mark - UIActionSheet method implementation

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
    }
    else if (actionSheet.tag == 200){
        NSLog(@"The Delete confirmation action sheet.");
    }
    else{
        NSLog(@"The Color selection action sheet.");
    }
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 300) {
        NSLog(@"From didDismissWithButtonIndex - Selected Color: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 300) {
        NSLog(@"From willDismissWithButtonIndex - Selected Color: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
}


#pragma mark - TestViewController Delegate method implementation

-(void)userDataChangedWithUsername:(NSString *)username andAgeRange:(NSString *)ageRange andGender:(NSString *)gender{
    NSLog(@"Your name is %@, your age range is %@ and your gender is %@", username, ageRange, gender);
    
    [self.userDataPopover dismissPopoverAnimated:YES];
}

@end
