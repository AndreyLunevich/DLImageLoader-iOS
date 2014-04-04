//
//  DLImageLoader.m
//
//  Created by Andrey Lunevich
//  Copyright 2013-2014 Andrey Lunevich. All rights reserved.

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "DLImageLoader.h"
#import "DLILCacheManager.h"
#import "DLILCache.h"

@interface DLImageLoader()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) DLILCacheManager *cacheManager;

@end

@implementation DLImageLoader

static DLImageLoader *_sharedInstance = nil;

+ (DLImageLoader *)sharedInstance
{
    static DLImageLoader* sharedInstance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.cacheManager = [[DLILCacheManager alloc] init];
        self.dlilLogEnable = YES;
        self.operationsLimit = 3;
    }
    return self;
}

- (void)loadDataFromUrl:(NSString *)urlString
              completed:(void (^)(NSError *, NSData *))completed
{
    // stop operations if more than limit.
    if ([[self.operationQueue operations] count] == self.operationsLimit) {
        [self stopDataLoading];
    }
    [self.operationQueue setSuspended:YES];
    // add new operation for loading data by url
    [self.operationQueue addOperationWithBlock:^{
        if (self.dlilLogEnable) NSLog(@"DLImageLoader start data loading");
        
        NSError *error = nil;
        NSData *image = nil;
        NSURL *url = [NSURL URLWithString:urlString];
        
        image = [self.cacheManager imageFromCache:urlString];
        if (image == nil && url != nil) {
            if (self.dlilLogEnable) NSLog(@"DLImageLoader loading from url");
            
            image = [NSData dataWithContentsOfURL:url options:0 error:&error];
            
            if (self.dlilLogEnable) NSLog(@"DLImageLoader saving to cache");
            
            [self.cacheManager addNewImageToCache:image url:urlString];
            [self.cacheManager saveCache];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.dlilLogEnable) NSLog(@"DLImageLoader data loading completed");
            
            if (completed) {
                completed(error, image);
            }
        }];
    }];
    [self.operationQueue setSuspended:NO];
}

- (void)loadImageFromUrl:(NSString *)urlString
               completed:(void (^)(NSError *, UIImage *))completed
{
    [self loadDataFromUrl:urlString completed:^(NSError *error, NSData *data) {
        if (completed) {
            completed(error, [UIImage imageWithData:data]);
        }
    }];
}

- (void)displayImageFromUrl:(NSString *)urlString
                  imageView:(UIImageView *)imageView
{
    imageView.image = nil;
    [self loadImageFromUrl:urlString completed:^(NSError *error, UIImage *image) {
        imageView.image = image;
        [imageView setNeedsDisplay];
    }];
}

- (void)stopDataLoading
{
    [self.operationQueue cancelAllOperations];
}

@end