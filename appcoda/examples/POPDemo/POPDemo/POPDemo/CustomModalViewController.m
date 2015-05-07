//
//  CustomModalViewController.m
//  POPDemo
//
//  Created by Simon Ng on 22/12/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "CustomModalViewController.h"

@interface CustomModalViewController ()

@end

@implementation CustomModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Round corner
    self.view.layer.cornerRadius = 8.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickOnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
