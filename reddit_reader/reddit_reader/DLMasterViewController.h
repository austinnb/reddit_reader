//
//  DLMasterViewController.h
//  reddit_reader
//
//  Created by Austin Brewer on 7/12/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLMasterViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *urlString;
@end
