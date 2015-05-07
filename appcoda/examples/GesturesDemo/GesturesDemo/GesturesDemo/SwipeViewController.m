//
//  SwipeViewController.m
//  GesturesDemo
//
//  Created by Gabriel Theodoropoulos on 8/22/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

@end

@implementation SwipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftOrange.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.viewOrange addGestureRecognizer:swipeRightOrange];
    [self.viewOrange addGestureRecognizer:swipeLeftOrange];
    
    
    UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.viewBlack addGestureRecognizer:swipeRightBlack];
    
    
    UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.viewGreen addGestureRecognizer:swipeLeftGreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, 320.0, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, 320.0, 0.0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, 320.0, 0.0);
    }];
}


-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -320.0, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, -320.0, 0.0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, -320.0, 0.0);
    }];
}

@end
