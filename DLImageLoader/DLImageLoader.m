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


#if DEBUG
#	define DLog(fmt, ...) \
{\
NSMutableString *__log_str__ = [[NSMutableString alloc]\
initWithFormat:fmt, ##__VA_ARGS__];\
fprintf(stderr, "%s %s\n", __FUNCTION__, [__log_str__ UTF8String]);\
}
#else
#    define DLog(...)
#endif


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

- (void)displayImageFromUrl:(NSString *)url
                  imageView:(UIImageView *)imageView
{
    [self displayImageFromRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                        imageView:imageView];
}

- (void)loadImageFromUrl:(NSString *)url
               completed:(void (^)(NSError *, UIImage *))completed
{
    [self loadImageFromUrl:url completed:completed canceled:nil];
}

- (void)loadImageFromUrl:(NSString *)url
               completed:(void (^)(NSError *, UIImage *))completed
                canceled:(void (^)())canceled
{
    [self loadImageFromRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                     completed:completed
                      canceled:canceled];
}

- (void)displayImageFromRequest:(NSURLRequest *)request
                      imageView:(UIImageView *)imageView
{
    imageView.image = nil;
    [self loadImageFromRequest:request completed:^(NSError *error, UIImage *image) {
        [self updateImageView:imageView image:image];
    } canceled:^{
        [self updateImageView:imageView image:nil];
    }];
}

- (void)loadImageFromRequest:(NSURLRequest *)request
                   completed:(void (^)(NSError *, UIImage *))completed
{
    [self loadImageFromRequest:request completed:completed canceled:nil];
}

- (void)loadImageFromRequest:(NSURLRequest *)request
                   completed:(void (^)(NSError *, UIImage *))completed
                    canceled:(void (^)())canceled
{
    NSString *url = request.URL.absoluteString;
    UIImage *image = [[DLILCacheManager sharedInstance] imageByKey:url];
    if (image) {
        DLog(@"=======");
        DLog(@"DLImageLoader: got an image from the cache");
        DLog(@"DLImageLoader: url of the image => %@", url);
        DLog(@"DLImageLoader: the resulting image => %@", image);
        DLog(@"=======");
        if (completed) {
            completed(nil, image);
        }
    } else {
        DLog(@"DLImageLoader: start image loading from url => %@", url);
        DLILOperation *operation = [[DLILOperation alloc] initWithRequest:request];
        [operation startLoadingWithCompletion:^(NSError *error, UIImage *image) {
            DLog(@"=======");
            DLog(@"DLImageLoader: loading completed");
            DLog(@"DLImageLoader: url of loaded image => %@", url);
            DLog(@"DLImageLoader: loaded image => %@", image);
            DLog(@"DLImageLoader: error of image loading => %@", error);
            DLog(@"=======");
            // save loaded image to cache
            [[DLILCacheManager sharedInstance] saveImage:image byKey:url];
            if (completed) {
                completed(error, image);
            }
        } canceled:^{
            DLog(@"DLImageLoader: image loading is canceled");
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

- (void)clearCache
{
    [[DLILCacheManager sharedInstance] clear];
}

@end