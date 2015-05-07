//
//  ViewController.m
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "NeighboursViewController.h"


@interface ViewController ()

@property (nonatomic, strong) NSArray *arrCountries;

@property (nonatomic, strong) NSArray *arrCountryCodes;

@property (nonatomic, strong) NSString *countryCode;

@property (nonatomic, strong) NSDictionary *countryDetailsDictionary;

-(void)getCountryInfo;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate of the textfield.
    self.txtCountry.delegate = self;
    
    // Make self the delegate and datasource of the table view.
    self.tblCountryDetails.delegate = self;
    self.tblCountryDetails.dataSource = self;
    
    // Initially hide the table view.
    self.tblCountryDetails.hidden = YES;
    
    
    // Load the contents of the two .txt files to the arrays.
    NSString *pathOfCountriesFile = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"txt"];
    NSString *pathOfCountryCodesFile = [[NSBundle mainBundle] pathForResource:@"countries_short" ofType:@"txt"];
    
    NSString *allCountries = [NSString stringWithContentsOfFile:pathOfCountriesFile encoding:NSUTF8StringEncoding error:nil];
    self.arrCountries = [[NSArray alloc] initWithArray:[allCountries componentsSeparatedByString:@"\n"]];
    
    NSString *allCountryCodes = [NSString stringWithContentsOfFile:pathOfCountryCodesFile encoding:NSUTF8StringEncoding error:nil];
    self.arrCountryCodes = [[NSArray alloc] initWithArray:[allCountryCodes componentsSeparatedByString:@"\n"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"idSegueNeighbours"]) {
        NeighboursViewController *neighboursViewController = [segue destinationViewController];
        neighboursViewController.geonameID = [self.countryDetailsDictionary objectForKey:@"geonameId"];
    }
}


#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // Find the index of the typed country in the arrCountries array.
    NSInteger index = -1;
    for (NSUInteger i=0; i<self.arrCountries.count; i++) {
        NSString *currentCountry = [self.arrCountries objectAtIndex:i];
        if ([currentCountry rangeOfString:self.txtCountry.text.uppercaseString].location != NSNotFound) {
            index = i;
            break;
        }
    }
    
    // Check if the given country was found.
    if (index != -1) {
        // Get the two-letter country code from the arrCountryCodes array.
        self.countryCode = [self.arrCountryCodes objectAtIndex:index];
        
        // Download the country info.
        [self getCountryInfo];
    }
    else{
        // If the country was not found then show an alert view displaying a relevant message.
        [[[UIAlertView alloc] initWithTitle:@"Country Not Found" message:@"The country you typed in was not found." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
    }
    
    // Hide the keyboard.
    [self.txtCountry resignFirstResponder];
    
    return YES;
}


#pragma mark - Private method implementation

-(void)getCountryInfo{
    // Prepare the URL that we'll get the country info data from.
    NSString *URLString = [NSString stringWithFormat:@"http://api.geonames.org/countryInfoJSON?username=%@&country=%@", kUsername, self.countryCode];
    NSURL *url = [NSURL URLWithString:URLString];
    
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                self.countryDetailsDictionary = [[returnedDict objectForKey:@"geonames"] objectAtIndex:0];
                
                // Set the country name to the respective label.
                self.lblCountry.text = [NSString stringWithFormat:@"%@ (%@)", [self.countryDetailsDictionary objectForKey:@"countryName"], [self.countryDetailsDictionary objectForKey:@"countryCode"]];
                
                // Reload the table view.
                [self.tblCountryDetails reloadData];
                
                // Show the table view.
                self.tblCountryDetails.hidden = NO;
            }
        }
    }];
}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = @"Capital";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"capital"];
            break;
        case 1:
            cell.detailTextLabel.text = @"Continent";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"continentName"];
            break;
        case 2:
            cell.detailTextLabel.text = @"Population";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"population"];
            break;
        case 3:
            cell.detailTextLabel.text = @"Area in Square Km";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"areaInSqKm"];
            break;
        case 4:
            cell.detailTextLabel.text = @"Currency";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"currencyCode"];
            break;
        case 5:
            cell.detailTextLabel.text = @"Languages";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"languages"];
            break;
        case 6:
            cell.textLabel.text = @"Neighbour Countries";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
            
        default:
            break;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        [self performSegueWithIdentifier:@"idSegueNeighbours" sender:self];
    }
}


#pragma mark - IBAction method implementation

- (IBAction)sendJSON:(id)sender {
    // Create a dictionary containing only the values we care about.
    NSDictionary *dictionary = @{@"countryName": [self.countryDetailsDictionary objectForKey:@"countryName"],
                                 @"countryCode": [self.countryDetailsDictionary objectForKey:@"countryCode"],
                                 @"capital": [self.countryDetailsDictionary objectForKey:@"capital"],
                                 @"continent": [self.countryDetailsDictionary objectForKey:@"continentName"],
                                 @"population": [self.countryDetailsDictionary objectForKey:@"population"],
                                 @"areaInSqKm": [self.countryDetailsDictionary objectForKey:@"areaInSqKm"],
                                 @"currency": [self.countryDetailsDictionary objectForKey:@"currencyCode"],
                                 @"languages": [self.countryDetailsDictionary objectForKey:@"languages"]
                                 };
    
    // Convert the dictionary into a JSON data object.
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    // Convert the JSON data into a string.
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setSubject:@"Country JSON"];
        
        [mailViewController setMessageBody:JSONString isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
