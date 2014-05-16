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
#import "DLILOperation.h"

@interface DLImageLoader()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) DLILCacheManager *cacheManager;

@end

@implementation DLImageLoader

+ (DLImageLoader *)sharedInstance
{
    static DLImageLoader* instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
        instance.operationQueue = [[NSOperationQueue alloc] init];
        instance.cacheManager = [[DLILCacheManager alloc] init];
        instance.isDLILLogEnabled = NO;
    });
    return instance;
}

- (void)loadImageFromUrl:(NSString *)urlString
               completed:(void (^)(NSError *, UIImage *))completed
{
    [self loadImageFromUrl:urlString completed:^(NSError *error, UIImage *image) {
        if (completed) completed(error, image);
    } canceled:nil];
}

- (void)loadImageFromUrl:(NSString *)urlString
               completed:(void (^)(NSError *, UIImage *))completed
                canceled:(void (^)())canceled
{
    if (self.isDLILLogEnabled) NSLog(@"DLImageLoader start data loading from %@", urlString);
    DLILOperation *operation = [[DLILOperation alloc] initWithUrl:urlString];
    [operation startLoadingWithCompletion:^(NSError *error, UIImage *image) {
        if (self.isDLILLogEnabled) NSLog(@"DLImageLoader data loading completed");
        if (completed) completed(error, image);
    } canceled:^{
        if (self.isDLILLogEnabled) NSLog(@"DLImageLoader data loading canceled");
        if (canceled) canceled();
    }];
    [self.operationQueue addOperation:operation];
}

- (void)displayImageFromUrl:(NSString *)urlString
                  imageView:(UIImageView *)imageView
{
    imageView.image = nil;
    [self loadImageFromUrl:urlString completed:^(NSError *error, UIImage *image) {
        imageView.image = image;
        [imageView setNeedsDisplay];
    } canceled:^{
        imageView.image = nil;
    }];
}

- (void)stopDataLoading
{
    for (DLILOperation *operation in self.operationQueue.operations) {
        [operation cancelLoading];
    }
}

@end