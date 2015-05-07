//
//  SecondViewController.m
//  TextKitDemo
//
//  Created by Gabriel Theodoropoulos on 21/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

-(void)addOrRemoveFontTraitWithName:(NSString *)traitName andValue:(uint32_t)traitValue;
-(void)setParagraphAlignment:(NSTextAlignment)newAlignment;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method implementation

-(void)addOrRemoveFontTraitWithName:(NSString *)traitName andValue:(uint32_t)traitValue{
    NSRange selectedRange = [_textView selectedRange];
    
    NSDictionary *currentAttributesDict = [_textView.textStorage attributesAtIndex:selectedRange.location
                                                                    effectiveRange:nil];
    
    UIFont *currentFont = [currentAttributesDict objectForKey:NSFontAttributeName];
    
    UIFontDescriptor *fontDescriptor = [currentFont fontDescriptor];
    
    NSString *fontNameAttribute = [[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorNameAttribute];
    UIFontDescriptor *changedFontDescriptor;
    
    if ([fontNameAttribute rangeOfString:traitName].location == NSNotFound) {
        uint32_t existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] | traitValue;
        changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithNewTrait];
    }
    else{
        uint32_t existingTraitsWithoutTrait = [fontDescriptor symbolicTraits] & ~traitValue;
        changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithoutTrait];
    }
    
    UIFont *updatedFont = [UIFont fontWithDescriptor:changedFontDescriptor size:0.0];
    
    NSDictionary *dict = @{NSFontAttributeName: updatedFont};
    
    [_textView.textStorage beginEditing];
    [_textView.textStorage setAttributes:dict range:selectedRange];
    [_textView.textStorage endEditing];
}


-(void)setParagraphAlignment:(NSTextAlignment)newAlignment{
    NSRange selectedRange = [_textView selectedRange];
    
    NSMutableParagraphStyle *newParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [newParagraphStyle setAlignment:newAlignment];
    
    NSDictionary *dict = @{NSParagraphStyleAttributeName: newParagraphStyle};
    [_textView.textStorage beginEditing];
    [_textView.textStorage setAttributes:dict range:selectedRange];
    [_textView.textStorage endEditing];
    
}


#pragma mark - IBAction method implementation

- (IBAction)makeBold:(id)sender {
    [self addOrRemoveFontTraitWithName:@"Bold" andValue:UIFontDescriptorTraitBold];
}


- (IBAction)makeItalic:(id)sender {
    [self addOrRemoveFontTraitWithName:@"Italic" andValue:UIFontDescriptorTraitItalic];
}


- (IBAction)underlineText:(id)sender {
    NSRange selectedRange = [_textView selectedRange];
    
    NSDictionary *currentAttributesDict = [_textView.textStorage attributesAtIndex:selectedRange.location
                                                                    effectiveRange:nil];
    
    NSDictionary *dict;
    
    if ([currentAttributesDict objectForKey:NSUnderlineStyleAttributeName] == nil ||
        [[currentAttributesDict objectForKey:NSUnderlineStyleAttributeName] intValue] == 0) {
        
        dict = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInt:1]};
        
    }
    else{
        dict = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInt:0]};
    }
    
    [_textView.textStorage beginEditing];
    [_textView.textStorage setAttributes:dict range:selectedRange];
    [_textView.textStorage endEditing];
}


- (IBAction)alignTextLeft:(id)sender {
    [self setParagraphAlignment:NSTextAlignmentLeft];
}


- (IBAction)centerText:(id)sender {
    [self setParagraphAlignment:NSTextAlignmentCenter];
}


- (IBAction)alignTextRight:(id)sender {
    [self setParagraphAlignment:NSTextAlignmentRight];
}


- (IBAction)makeTextColorRed:(id)sender {
    NSRange selectedRange = [_textView selectedRange];
    
    NSDictionary *currentAttributesDict = [_textView.textStorage attributesAtIndex:selectedRange.location
                                                                    effectiveRange:nil];
    
    if ([currentAttributesDict objectForKey:NSForegroundColorAttributeName] == nil ||
        [currentAttributesDict objectForKey:NSForegroundColorAttributeName] != [UIColor redColor]) {
        
        NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor redColor]};
        [_textView.textStorage beginEditing];
        [_textView.textStorage setAttributes:dict range:selectedRange];
        [_textView.textStorage endEditing];
    }
}


- (IBAction)makeTextColorBlack:(id)sender {
    NSRange selectedRange = [_textView selectedRange];
    
    NSDictionary *currentAttributesDict = [_textView.textStorage attributesAtIndex:selectedRange.location
                                                                    effectiveRange:nil];
    
    if ([currentAttributesDict objectForKey:NSForegroundColorAttributeName] == nil ||
        [currentAttributesDict objectForKey:NSForegroundColorAttributeName] != [UIColor blackColor]) {
        
        NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        [_textView.textStorage beginEditing];
        [_textView.textStorage setAttributes:dict range:selectedRange];
        [_textView.textStorage endEditing];
    }
}

@end
