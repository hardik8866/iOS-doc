//
//  FirstViewController.m
//  DynamicsDemo
//
//  Created by Gabriel Theodoropoulos on 7/3/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) UIView *orangeBall;

@property (nonatomic, strong) UIView *paddle;

@property (nonatomic) BOOL isBallRolling;

@property (nonatomic) CGPoint paddleCenterPoint;


-(void)demoGravity;
-(void)playWithBall;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Setup the ball view.
    //self.orangeBall = [[UIView alloc] initWithFrame:CGRectMake(100.0, 100.0, 50.0, 50.0)];
    self.orangeBall = [[UIView alloc] initWithFrame:CGRectMake(0.0, 10.0, 50.0, 50.0)];
    self.orangeBall.backgroundColor = [UIColor orangeColor];
    self.orangeBall.layer.cornerRadius = 25.0;
    self.orangeBall.layer.borderColor = [UIColor blackColor].CGColor;
    self.orangeBall.layer.borderWidth = 0.0;
    [self.view addSubview:self.orangeBall];
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //[self demoGravity];
    [self playWithBall];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method implementation

-(void)demoGravity{
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    [self.animator addBehavior:gravityBehavior];
    
//    gravityBehavior.action = ^{
//        NSLog(@"%f", self.orangeBall.center.y);
//    };
    
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];
    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
                                       fromPoint:self.tabBarController.tabBar.frame.origin
                                         toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    [self.animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
    
    
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.75;
//    ballBehavior.resistance = 0.0;
//    ballBehavior.friction = 0.0;
//    ballBehavior.allowsRotation = NO;
    [self.animator addBehavior:ballBehavior];
}


-(void)playWithBall{
    UIView *obstacle1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 80.0, 120.0, 20.0)];
    obstacle1.backgroundColor = [UIColor blueColor];
    
    UIView *obstacle2 = [[UIView alloc] initWithFrame:CGRectMake(170.0, 200.0, 150.0, 20.0)];
    obstacle2.backgroundColor = [UIColor blueColor];
    
    UIView *obstacle3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75,
                                                                 320.0,
                                                                 150.0,
                                                                 20.0)];
    obstacle3.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:obstacle1];
    [self.view addSubview:obstacle2];
    [self.view addSubview:obstacle3];
    
    
    self.paddle = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75,
                                                           self.tabBarController.tabBar.frame.origin.y - 35.0,
                                                           150.0,
                                                           30.0)];
    self.paddle.backgroundColor = [UIColor greenColor];
    self.paddle.layer.cornerRadius = 15.0;
    self.paddleCenterPoint = self.paddle.center;
    [self.view addSubview:self.paddle];
    
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    [self.animator addBehavior:gravityBehavior];
    
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall, self.paddle, obstacle1, obstacle2, obstacle3]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
                                       fromPoint:self.tabBarController.tabBar.frame.origin
                                         toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.9;
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.0;
    ballBehavior.allowsRotation = NO;
    [self.animator addBehavior:ballBehavior];
    
    
    UIDynamicItemBehavior *obstacles1And2Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[obstacle1, obstacle2]];
    obstacles1And2Behavior.allowsRotation = NO;
    obstacles1And2Behavior.density = 100000.0;
    [self.animator addBehavior:obstacles1And2Behavior];
    
    
    UIDynamicItemBehavior *obstacle3Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[obstacle3]];
    obstacle3Behavior.allowsRotation = YES;
    [self.animator addBehavior:obstacle3Behavior];
    
    
    UIDynamicItemBehavior *paddleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddle]];
    paddleBehavior.allowsRotation = NO;
    paddleBehavior.density = 100000.0;
    [self.animator addBehavior:paddleBehavior];
}


#pragma mark - Touch Events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.isBallRolling) {
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.orangeBall] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.magnitude = 1.5;
        [self.animator addBehavior:pushBehavior];
        
        self.isBallRolling = YES;
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    CGFloat yPoint = self.paddleCenterPoint.y;
    CGPoint paddleCenter = CGPointMake(touchLocation.x, yPoint);
    
    self.paddle.center = paddleCenter;
    [self.animator updateItemUsingCurrentState:self.paddle];
}


#pragma mark - UICollisionBehavior Delegate method implementation

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    
    //self.orangeBall.backgroundColor = [UIColor blueColor];
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    
    //self.orangeBall.backgroundColor = [UIColor orangeColor];
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
    if (item1 == self.orangeBall && item2 == self.paddle) {
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.orangeBall] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.angle = 0.0;
        pushBehavior.magnitude = 0.75;
        [self.animator addBehavior:pushBehavior];
    }
}

@end
