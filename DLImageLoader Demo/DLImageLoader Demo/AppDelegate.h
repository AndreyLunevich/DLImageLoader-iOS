//
//  AppDelegate.h
//  DLImageLoader Demo
//
//  Created by Andrey Lunevich on 7/12/13.
//  Copyright (c) 2013 Andrey Lunevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder
<
    UIApplicationDelegate,
    DLImageLoaderDelegate
>

@property (strong, nonatomic) UIWindow *window;

@end