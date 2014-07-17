//
//  DLUserContainer.h
//  reddit_reader
//
//  Created by Jeff Burt on 7/17/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLUserContainer : NSObject
@property NSString *textBody;
@property NSString *subreddit;
@property NSURL *url;
@end
