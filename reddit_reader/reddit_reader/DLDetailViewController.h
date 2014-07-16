//
//  DLDetailViewController.h
//  reddit_reader
//
//  Created by Austin Brewer on 7/12/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLDetailViewController : UIViewController
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

/*@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;*/
@end
