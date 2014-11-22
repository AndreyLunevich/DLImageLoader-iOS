//
//  DLILOperation.m
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

#import "DLILOperation.h"
#import "DLILCacheManager.h"

@interface DLILOperation()

@property (nonatomic, copy) CompletionBlock completed;
@property (nonatomic, copy) CancelBlock canceled;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation DLILOperation

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        [self configWithUrl:url];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self configWithUrl:nil];
    }
    return self;
}

- (void)configWithUrl:(NSString *)url
{
    self.url = url;
    self.data = [[NSMutableData alloc] init];
}

- (void)start
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self];
    if (_connection == nil) {
        [self cancel];
    }
}

- (void)startLoadingWithCompletion:(CompletionBlock)completed
                          canceled:(CancelBlock)canceled
{
    if (!self.url || [self.url isEqualToString:@""]) {
        // fail loading
        if (completed) completed(nil, nil);
        return;
    }
    
    self.completed = completed;
    self.canceled = canceled;
}

- (void)cancel
{
    [_connection cancel];
    _connection = nil;
    [self.data setData:[NSData dataWithBytes:NULL length:0]];
    if (self.canceled) self.canceled();
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:self.data];
    [[DLILCacheManager sharedInstance] saveImage:image byKey:self.url];
    // successfull loading
    if (self.completed) self.completed(nil, image);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // fail loading
    if (self.completed) self.completed(error, nil);
}

@end