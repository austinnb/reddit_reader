//
//  DLSubredditSearchViewController.m
//  reddit_reader
//
//  Created by Austin Brewer on 7/13/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import "DLSubredditSearchViewController.h"

@interface DLSubredditSearchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation DLSubredditSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.submitButton) return;
    [[segue destinationViewController] setUrlString:self.urlString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
