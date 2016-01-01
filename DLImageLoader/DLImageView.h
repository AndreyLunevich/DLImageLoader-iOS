//
//  DLImageView.h
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

#import <UIKit/UIKit.h>

@interface DLImageView : UIImageView

/**
 Load image from url
 @param urlString The url of image.
 @param completed Completed is a completion block that will call after image loading.
 */
- (void)imageFromUrl:(NSString *)url
           completed:(void(^)(NSError *error, UIImage *image))completed;

/**
 Display image from url
 @param urlString The url of image.
 */
- (void)imageFromUrl:(NSString *)url;

/**
 Load image from request
 @param request The request of image.
 @param completed Completed is a completion block that will call after image loading.
 */
- (void)imageFromRequest:(NSURLRequest *)request
               completed:(void(^)(NSError *error, UIImage *image))completed;

/**
 Display image from request
 @param request The request of image.
 */
- (void)imageFromRequest:(NSURLRequest *)request;

/**
 Cancel started operation
 */
- (void)cancelLoading;

@end
