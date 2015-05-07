//
//  FirstViewController.m
//  TextKitDemo
//
//  Created by Gabriel Theodoropoulos on 21/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (nonatomic, strong) NSString *styleApplied;

-(void)textSizeChangedWithNotification:(NSNotification *)notification;
-(void)applyStyletoSelection:(NSString *)style;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textSizeChangedWithNotification:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    [_imageView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method implementation

-(void)textSizeChangedWithNotification:(NSNotification *)notification{
    [_textView setFont:[UIFont preferredFontForTextStyle:_styleApplied]];
}


-(void)applyStyletoSelection:(NSString *)style{
    NSRange range = [_textView selectedRange];
    UIFont *styledFont = [UIFont preferredFontForTextStyle:style];
    [_textView.textStorage beginEditing];
    NSDictionary *dict = @{NSFontAttributeName : styledFont};
    [_textView.textStorage setAttributes:dict range:range];
    [_textView.textStorage endEditing];
}


#pragma mark - IBAction method implementation

- (IBAction)applyHeadlineStyle:(id)sender {
//    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
//    _styleApplied = UIFontTextStyleHeadline;
    
    [self applyStyletoSelection:UIFontTextStyleHeadline];
}

- (IBAction)applySubHeadlineStyle:(id)sender {
//    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
//    _styleApplied = UIFontTextStyleSubheadline;
    
    [self applyStyletoSelection:UIFontTextStyleSubheadline];
}

- (IBAction)applyBodyStyle:(id)sender {
//    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
//    _styleApplied = UIFontTextStyleBody;
    
    [self applyStyletoSelection:UIFontTextStyleBody];
}

- (IBAction)applyFootnoteStyle:(id)sender {
//    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
//    _styleApplied = UIFontTextStyleFootnote;
    
    [self applyStyletoSelection:UIFontTextStyleFootnote];
}

- (IBAction)applyCaption1Style:(id)sender {
//    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
//    _styleApplied = UIFontTextStyleCaption1;
    
    [self applyStyletoSelection:UIFontTextStyleCaption1];
}

- (IBAction)applyCaption2Style:(id)sender {
//    [_textView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]];
//    _styleApplied = UIFontTextStyleCaption2;
    
    [self applyStyletoSelection:UIFontTextStyleCaption2];
}


- (IBAction)toggleImage:(id)sender{
    if ([_imageView isHidden]) {
        CGRect convertedFrame = [_textView convertRect:_imageView.frame fromView:self.view];
        [[_textView textContainer] setExclusionPaths:@[[UIBezierPath bezierPathWithRect:convertedFrame]]];
    }
    else{
        [[_textView textContainer] setExclusionPaths:nil];
    }
    
    [_imageView setHidden:![_imageView isHidden]];
}


@end
