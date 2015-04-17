//
//  DLMasterViewController.m
//  reddit_reader
//
//  Created by Austin Brewer on 7/12/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import "DLMasterViewController.h"

#import "DLDetailViewController.h"

#import "DLSubredditContainer.h"

#import "DLUserContainer.h"

@interface DLMasterViewController () {
    NSMutableArray *_objects;
    NSMutableDictionary *dictionary;
    NSMutableData *redditData;
}
@end

@implementation DLMasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // make a connection to reddit
    NSString *insert = [NSString stringWithFormat:@"http://www.reddit.com%@/.json", self.urlString];
    NSURL *myURL = [NSURL URLWithString:insert];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
    [myConnection start];
    
    //pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
    //Navigation stuff (comment this out later)
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //get response and log it. if 404 error, display alert
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    int errorCode = httpResponse.statusCode;
    if (errorCode == 404) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NetworkError" message:@"Oh no! That page doesn't exist. Try /r/adviceanimals" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    NSLog(@"response is %d %@", errorCode, fileMIMEType);
    
    //we have a connection, so we can allocate/innitialize the data object
    redditData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //push the data we recieve into our data object
    [redditData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //make a readable error string to log and display in an alert
    NSString *errorString = [NSString stringWithFormat:@"Connection failed. Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(errorString);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NetworkError" message:errorString delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded!");
    //WOO! we finished loading, lets put that data in a dictionary
    dictionary = [[NSMutableDictionary alloc] init];
    NSError *e;
    dictionary = [NSJSONSerialization JSONObjectWithData:redditData options:0 error:&e];
    
    //reddit displays 25 items by default so lets find them in the dectionary and make some post objects
    //(DLRedditContainers) to fill _objects.
    _objects = [[NSMutableArray alloc] initWithCapacity:25];
    for (NSMutableDictionary *childrenDictionary in dictionary[@"data"][@"children"]) {
        
        if ([childrenDictionary[@"kind"] isEqualToString:@"t3"]) {
            NSLog(@"%@", childrenDictionary[@"data"][@"title"]);
            NSLog(@"%@", childrenDictionary[@"data"][@"subreddit"]);
            NSLog(@"%@", childrenDictionary[@"data"][@"url"]);
            NSLog(@"%@", childrenDictionary[@"data"][@"thumbnail"]);
            DLSubredditContainer *subPost = [[DLSubredditContainer alloc] init];
            subPost.title = childrenDictionary[@"data"][@"title"];
            subPost.url = [NSURL URLWithString:childrenDictionary[@"data"][@"url"]];
            subPost.subreddit = childrenDictionary[@"data"][@"subreddit"];
            subPost.thumbnail = childrenDictionary[@"data"][@"thumbnail"];
            [_objects addObject:subPost];
        } else if ([childrenDictionary[@"kind"] isEqualToString:@"t1"]) {
            DLUserContainer *userPost = [[DLUserContainer alloc] init];
            userPost.textBody = childrenDictionary[@"data"][@"body"];
            userPost.url = [NSURL URLWithString:childrenDictionary[@"data"][@"link_url"]];
            userPost.subreddit = childrenDictionary[@"data"][@"subreddit"];
            [_objects addObject:userPost];
        } else {
            //FIXME
        }
    }
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)downloadImageWithURL:(NSString *)urlString completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
    
}

- (void)refreshTable:(UIRefreshControl *)refresh {
    [refresh endRefreshing];
    [self.tableView reloadData];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // build our cells from objects. they need a title, subtitle (subreddit), url, and thumbnail
    // url for images in the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"Untitled-1"];
    
    if ([_objects[indexPath.row] isKindOfClass:[DLSubredditContainer class]]) {
        DLSubredditContainer *subredditObject = _objects[indexPath.row];
        cell.textLabel.text = subredditObject.title;
        cell.detailTextLabel.text = subredditObject.subreddit;
        [self downloadImageWithURL:subredditObject.thumbnail completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                cell.imageView.image = image;
                
                // /r/earthporn was really giving me issue with rezising the thumbnail
                // this keeps it at 50x50
                CGSize itemSize = CGSizeMake(50, 50);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [cell.imageView.image drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }
        }];
    } else {
        DLUserContainer *userObject = _objects[indexPath.row];
        cell.textLabel.text = userObject.textBody;
        cell.detailTextLabel.text = userObject.subreddit;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //pass the selected cells url string to the detail view controllers url property
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    id object = _objects[indexPath.row];
    NSURL *url;
    if ([object isKindOfClass:[DLSubredditContainer class]]) {
        DLSubredditContainer *post = object;
        url = [post url];
    } else {
        DLUserContainer *post = object;
        url = post.url;
    }
    
    [[segue destinationViewController] setUrl:url];
    
    
}

@end
