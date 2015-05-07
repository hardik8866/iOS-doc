//
//  CustomActionSheet.h
//  BlockDemo
//
//  Created by Gabriel Theodoropoulos on 22/1/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomActionSheet : NSObject <UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

-(void)showInView:(UIView *)view withCompletionHandler:(void(^)(NSString *buttonTitle, NSInteger buttonIndex))handler;

@end
