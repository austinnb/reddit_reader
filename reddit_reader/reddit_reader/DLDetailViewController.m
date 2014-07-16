//
//  DLDetailViewController.m
//  reddit_reader
//
//  Created by Austin Brewer on 7/12/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import "DLDetailViewController.h"

@interface DLDetailViewController ()
- (void)configureView;
@end

@implementation DLDetailViewController

#pragma mark - Managing the detail item

- (void)configureView
{
    // Update the user interface for the detail item.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // uhh, I made a request and gave it to the webview
    NSURL *myURL = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
