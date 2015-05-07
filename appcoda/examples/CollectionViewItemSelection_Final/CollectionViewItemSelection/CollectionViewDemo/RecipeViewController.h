//
//  RecipeViewController.h
//  CollectionViewDemo
//
//  Created by Simon on 16/2/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) NSString *recipeImageName;

- (IBAction)close:(id)sender;


@end
