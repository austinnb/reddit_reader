//
//  DLSearchViewController.m
//  reddit_reader
//
//  Created by Austin Brewer on 7/13/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import "DLSearchViewController.h"
#import "DLMasterViewController.h"

@interface DLSearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@end

@implementation DLSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // my very poorly written subreddit regex and a predicate to test the textField with
    NSString *subredditRegex = @"(/r/+([a-zA-Z0-9]*)";
    NSPredicate *subredditTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", subredditRegex];
    
    // if the input is messed up display an alert and log it. else go ahead and return (segue to masterViewController)
    if ([textField.text isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"Results" sender:self];
        return YES;
    }
    BOOL result = [subredditTest evaluateWithObject:textField.text];
    if (!result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Hey, it looks like your subreddit isn't quite right. Try /r/yoursubreddit instead" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        NSLog(@"Error- Invalid input in search text field");
    } else {
        [self performSegueWithIdentifier:@"Results" sender:self];
        //[textField resignFirstResponder];
    }
    return result;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //bye bye keyboard when white space is touched
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // pass the subreddit to the masterViewcontroller for insertion into the url
    [[segue destinationViewController] setUrlString:self.textFeild.text];
}


@end
