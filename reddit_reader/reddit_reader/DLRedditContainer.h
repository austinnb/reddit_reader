//
//  DLRedditContainer.h
//  reddit_reader
//
//  Created by Austin Brewer on 7/13/14.
//  Copyright (c) 2014 Austin Brewer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLRedditContainer : NSObject
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* subreddit;
@property (strong, nonatomic) NSString* thumbnail;
@end
