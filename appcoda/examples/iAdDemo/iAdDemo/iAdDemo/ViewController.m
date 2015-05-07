//
//  ViewController.m
//  iAdDemo
//
//  Created by Gabriel Theodoropoulos on 10/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) int secondsElapsed;

@property (nonatomic) BOOL pauseTimeCounting;


-(void)showTimerMessage;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate of the ad banner.
    self.adBanner.delegate = self;
    
    // Initially hide the ad banner.
    self.adBanner.alpha = 0.0;
    
    
    // Start the timer.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimerMessage) userInfo:nil repeats:YES];
    
    // Set the initial value for the elapsed seconds.
    self.secondsElapsed = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method implementation

-(void)showTimerMessage{
    if (!self.pauseTimeCounting) {
        self.secondsElapsed++;
        
        self.lblTimerMessage.text = [NSString stringWithFormat:@"You've been viewing this view for %d seconds", self.secondsElapsed];
    }
    else{
        self.lblTimerMessage.text = @"Paused to show ad...";
    }
}


#pragma mark - AdBannerViewDelegate method implementation

-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner will load ad.");
}


-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner did load ad.");
    
    // Show the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        self.adBanner.alpha = 1.0;
    }];
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"Ad Banner action is about to begin.");
    
    self.pauseTimeCounting = YES;
    
    return YES;
}


-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad Banner action did finish");
    
    self.pauseTimeCounting = NO;
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
    
    // Hide the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        self.adBanner.alpha = 0.0;
    }];
}

@end
