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
#import "DLImageLoader.h"

@interface DLImageView()

@property (nonatomic, copy) NSString *url;

@end

@implementation DLImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureView];
}

- (void)configureView
{
    self.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)displayImageFromUrl:(NSString *)url
{
    [self loadImageFromUrl:url completed:^(NSError *error, UIImage *image) {
        self.image = image;
    }];
}

- (void)loadImageFromUrl:(NSString *)url
               completed:(void (^)(NSError *, UIImage *))completed
{
    self.url = url;
    self.image = nil;
    [[DLImageLoader sharedInstance] loadImageFromUrl:url completed:completed];
}

- (void)cancelLoading
{
    [[DLImageLoader sharedInstance] cancelOperation:self.url];
}

@end