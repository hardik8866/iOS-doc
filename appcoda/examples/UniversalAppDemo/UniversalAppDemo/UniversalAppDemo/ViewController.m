//
//  ViewController.m
//  UniversalAppDemo
//
//  Created by Simon on 17/10/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

- (IBAction)play:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // For iPhone
        UIAlertView *playAlert = [[UIAlertView alloc] initWithTitle:@"New Game" message:@"Start Playing..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [playAlert show];
        
    } else {
        // For iPad
        UIAlertView *playAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Just ended..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [playAlert show];
    }
}
@end
