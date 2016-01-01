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

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation DLImageLoader

+ (DLImageLoader *)sharedInstance
{
    static DLImageLoader* instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
        instance.queue = [[NSOperationQueue alloc] init];
    });
    return instance;
}

#pragma mark - loading methods

- (void)imageFromUrl:(NSString *)url imageView:(UIImageView *)imageView
{
    [self imageFromRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                 imageView:imageView];
}

- (void)imageFromUrl:(NSString *)url
           completed:(void (^)(NSError *, UIImage *))completed
{
    [self imageFromUrl:url completed:completed canceled:nil];
}

- (void)imageFromUrl:(NSString *)url
           completed:(void (^)(NSError *, UIImage *))completed
            canceled:(void (^)())canceled
{
    [self imageFromRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                 completed:completed
                  canceled:canceled];
}

- (void)imageFromRequest:(NSURLRequest *)request imageView:(UIImageView *)imageView
{
    imageView.image = nil;
    [self imageFromRequest:request completed:^(NSError *error, UIImage *image) {
        [self updateImageView:imageView image:image];
    } canceled:^{
        [self updateImageView:imageView image:nil];
    }];
}

- (void)imageFromRequest:(NSURLRequest *)request
               completed:(void (^)(NSError *, UIImage *))completed
{
    [self imageFromRequest:request completed:completed canceled:nil];
}

- (void)imageFromRequest:(NSURLRequest *)request
               completed:(void (^)(NSError *, UIImage *))completed
                canceled:(void (^)())canceled
{
    NSString *url = request.URL.absoluteString;
    UIImage *image = [[DLILCacheManager sharedInstance] imageByKey:url];
    [self printLog:[NSString stringWithFormat:@"DLImageLoader: image with url => %@", url]];
    if (image) {
        [self printLog:@"DLImageLoader: got an image from the cache"];
        if (completed) {
            completed(nil, image);
        }
    } else {
        DLILOperation *operation = [[DLILOperation alloc] initWithRequest:request];
        [operation startLoadingWithCompletion:^(NSError *error, UIImage *image) {
            if (error) {
                [self printLog:[NSString stringWithFormat:@"DLImageLoader: error of image loading => %@", error]];
            } else {
                [self printLog:[NSString stringWithFormat:@"DLImageLoader: loaded image with url => %@", url]];
            }
            // save loaded image to cache
            [[DLILCacheManager sharedInstance] saveImage:image byKey:url];
            if (completed) {
                completed(error, image);
            }
        } canceled:^{
            [self printLog:@"DLImageLoader: image loading is canceled"];
            if (canceled) {
                canceled();
            }
        }];
        [self.queue addOperation:operation];
    }
}

- (void)updateImageView:(UIImageView *)imageView image:(UIImage *)image
{
    imageView.image = image;
    [imageView setNeedsDisplay];
}

#pragma mark - cancel operations methods

- (void)cancelOperation:(NSString *)url
{
    for (DLILOperation *operation in self.queue.operations) {
        if ([operation.url isEqualToString:url]) {
            [operation cancel];
        }
    }
}

- (void)cancelAllOperations
{
    for (DLILOperation *operation in self.queue.operations) {
        [operation cancel];
    }
}

#pragma mark - clear cache methods

- (void)clearCache:(void (^)(BOOL))completed
{
    [[DLILCacheManager sharedInstance] clear:completed];
}

#pragma mark - log

- (void)printLog:(NSString *)message
{
    if ([self.delegate conformsToProtocol:@protocol(DLImageLoaderDelegate)] &&
        [self.delegate respondsToSelector:@selector(DLILLog:)]) {
        [self.delegate DLILLog:message];
    }
}

@end
