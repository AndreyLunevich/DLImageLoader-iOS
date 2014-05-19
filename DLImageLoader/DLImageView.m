//
//  DLImageView.m
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

#import "DLImageView.h"
#import "DLILOperation.h"

@interface DLImageView()

@property (nonatomic, strong) DLILOperation *operation;

@end

@implementation DLImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareDLImageView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self prepareDLImageView];
}

- (void)prepareDLImageView
{
    self.operation = [[DLILOperation alloc] init];
}

- (void)displayImageFromUrl:(NSString *)urlString
{
    [self loadImageFromUrl:urlString completed:^(NSError *error, UIImage *image) {
        self.image = image;
    }];
}

- (void)loadImageFromUrl:(NSString *)urlString completed:(void (^)(NSError *, UIImage *))completed
{
    self.image = nil;
    [self.operation cancelLoading];
    [self.operation setUrl:urlString];
    [self.operation startLoadingWithCompletion:^(NSError *error, UIImage *image) {
        if (completed) completed(error, image);
    } canceled:nil];
}

@end