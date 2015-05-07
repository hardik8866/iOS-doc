//
//  ViewController.h
//  iAdDemo
//
//  Created by Gabriel Theodoropoulos on 10/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

@property (weak, nonatomic) IBOutlet UILabel *lblTimerMessage;

@end
