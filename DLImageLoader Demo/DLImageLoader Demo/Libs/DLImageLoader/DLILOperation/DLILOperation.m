//
//  DLILOperation.m
//
//  Created by Andrey Lunevich on 7/9/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import "DLILOperation.h"

@implementation DLILOperation

static dispatch_queue_t dlil_background_queue;

dispatch_queue_t dlil_queue() {
    if (dlil_background_queue == NULL) {
        dlil_background_queue = dispatch_queue_create("com.lunevich.background", 0);
    }
    return dlil_background_queue;
}

+ (void)newOperationWithBlock:(void(^)(void))operation
                    completed:(void(^)(void))completed {
    dispatch_async(dlil_queue(), ^{
        operation();
        dispatch_async(dispatch_get_main_queue(), ^{
            completed();
        });
    });
}

+ (void)newOperationWithBlock:(void(^)(void))operation {
    dispatch_async(dlil_queue(), ^{
        operation();
    });
}

@end