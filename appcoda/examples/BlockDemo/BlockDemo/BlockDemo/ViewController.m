//
//  ViewController.m
//  BlockDemo
//
//  Created by Gabriel Theodoropoulos on 19/1/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "ViewController.h"
#import "CustomActionSheet.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *(^blockAsAMemberVar)(void);
@property (nonatomic, strong) CustomActionSheet *customActionSheet;

-(void)testBlockStorageType;

-(void)addNumber:(int)number1 withNumber:(int)number2 andCompletionHandler:(void (^)(int result))completionHandler;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Here are some block declaration examples.
    /**
     int (^firstBlock)(NSString *param1, int param2);
     void (^showName)(NSString *myName);
     NSDate *(^whatDayIsIt)(void);
     void (^allVoid)(void);
     NSString *(^composeName)(NSString *firstName, NSString *lastName);
     **/
    
    
    
    // Basic block definition.
    ^(int a, int b){
        int result = a * b;
        return result;
    };
    
    
    
    // Block declaration, definition and call.
    int (^howMany)(int, int) = ^(int a, int b){
        return a + b;
    };
    
    NSLog(@"%d", howmany(5, 10));
    
    
    // Defining block and assigning it to a block variable.
    void (^justAMessage)(NSString *) = ^(NSString *message){
        NSLog(@"%@", message);
    };
    
    
    
    // Assigning block to variable declared elsewhere else.
    void (^xyz)(void);
    // Some other code...
    
    // Define the block.
    xyz = ^(void){
        NSLog(@"What's up, Doc?");
    };
    
    
    
    // Making calls to block variables.
    NSDate *(^today)(void);
    
    today = ^(void){
        return [NSDate date];
    };
    
    NSLog(@"%@", today());
    
    
    float results = ^(float value1, float value2, float value3){
        return value1 * value2 * value3;
    } (1.2, 3.4, 5.6);
    
    NSLog(@"%f", results);
    
    
    int factor = 5;
    int (^newResult)(void) = ^(void){
        return factor * 10;
    };
    
    NSLog(@"%d", newResult());
    
    
    
    // Assigning block to a class member variable.
    _blockAsAMemberVar = ^(void){
        return @"This block is declared as a member variable!";
    };
    
    NSLog(@"%@", _blockAsAMemberVar());
    
    
    
    // Testing the __block storage type.
    [self testBlockStorageType];
    
    
    
    // A couple of examples where blocks are used.
    
    //    [self presentViewController:nil animated:YES completion:^{
    //        NSLog(@"View Controller was presented...");
    //
    //        // Other code related to view controller presentation...
    //    }];
    
    
    //    [UIView animateWithDuration:0.5
    //                     animations:^{
    //                         // Animation-related code here...
    //                         [self.view setAlpha:0.5];
    //                     }
    //                     completion:^(BOOL finished) {
    //                         // Any completion handler related code here...
    //
    //                         NSLog(@"Animation is over.");
    //                     }];
    
    
    
    // Completion handler implementation.
    [self addNumber:5 withNumber:7 andCompletionHandler:^(int result) {
        // We just log the result, no need to do anything else.
        NSLog(@"The result is %d", result);
    }];
    
    
    // Blocks and Multithreading.
    NSLog(@"Preparing to run code in secondary thread...");
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue", NULL);
    dispatch_async(myQueue, ^{
        NSLog(@"Running code in secondary thread...");
        
        int value = 0;
        for (int i=0; i<100; i++) {
            for (int j=0; j<100; j++) {
                for (int n=0; n<100; n++) {
                    value += j;
                }
            }
        }
        
        NSLog(@"From secondary thread: value = %d", value);
    });
    
    NSLog(@"This is main thread again...");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)testBlockStorageType{
    __block int someValue = 10;
    
    int (^myOperation)(void) = ^(void){
        someValue += 5;
        
        return someValue + 10;
    };
    
    NSLog(@"%d", myOperation());
}


-(void)addNumber:(int)number1 withNumber:(int)number2 andCompletionHandler:(void (^)(int result))completionHandler{
    int result = number1 + number2;
    completionHandler(result);
}


- (IBAction)showActionSheet:(id)sender {
    _customActionSheet = [[CustomActionSheet alloc] initWithTitle:@"AppCoda"
                                                         delegate:nil
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Option 1", @"Option 2", @"Option 3", nil];
    
    [_customActionSheet showInView:self.view withCompletionHandler:^(NSString *buttonTitle, NSInteger buttonIndex) {
        NSLog(@"You tapped the button at index: %d", buttonIndex);
        NSLog(@"Your selection is: %@", buttonTitle);
    }];
}

@end
