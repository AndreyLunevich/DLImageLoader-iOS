//
//  DLImageLoader.h
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLImageLoader : NSObject

/** Load image from url
 @param urlString The url of image
 */
+ (void)loadImageFromURL:(NSString *)urlString
               completed:(void(^)(NSError *error, NSData *imgData))completed;

@end