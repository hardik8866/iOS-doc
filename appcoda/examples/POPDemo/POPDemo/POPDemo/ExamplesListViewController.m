//
//  ExamplesListViewController.m
//  POPDemo
//
//  Created by Simon Ng on 19/12/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "ExamplesListViewController.h"

@interface ExamplesListViewController ()
@property (nonatomic, strong) NSArray *examples;
@end

@implementation ExamplesListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.examples = @[@"Facebook Like & Send", @"Wrong Password", @"Custom VC Transition"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.examples.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exampleCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.examples[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"openFB" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"openWrongPass" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"openCustomTransition" sender:self];
            break;
            
        default:
            break;
    }
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
