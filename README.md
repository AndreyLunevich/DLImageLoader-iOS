DLImageLoader-iOS
=================

Image Loader for iOS. <br/>
This project aims to provide a reusable instrument for asynchronous image loading, caching and displaying.

![Screenshot](https://raw.githubusercontent.com/AndreyLunevich/DLImageLoader-iOS/master/dlil.png)

## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add DLImageLoader to your project.

1. Add a pod entry for DLImageLoader to your Podfile `pod 'DLImageLoader', '~> 2.0.0'`
2. Install the pod(s) by running `pod install`.
3. Include DLImageLoader wherever you need it with `#import "DLIL.h"`.

### Source files

Alternatively you can directly add the `DLImageLoader` folder to your project.

1. Download the latest code version or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `DLImageLoader` folder onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include DLImageLoader wherever you need it with <pre>#import "DLIL.h"</pre> (e.g. SomeViewController.m or AppName-Prefix.pch).

## Usage

### Simple

<pre>
[[DLImageLoader sharedInstance] displayImageFromUrl:@"image_url_here"
                                          imageView:@"UIImageView here"];
</pre>

### Complete

// === Two possible variants === //

<pre>
[[DLImageLoader sharedInstance] loadImageFromUrl:@"image_url_here"
                                       completed:^(NSError *error, UIImage *image) {
                                            if (error == nil) {
                                                // if we have no any errors
                                            } else {
                                                // if we got an error when load an image
                                            }
                                       }];
</pre>
<pre>
[[DLImageLoader sharedInstance] loadDataFromUrl:@"file_url_here"
                                      completed:^(NSError *error, NSData *data) {
                                            // do anything you want
                                      }];
</pre>


## Applications using DLImageLoader

[Nootri The Nutrition Manager](https://itunes.apple.com/US/app/id912109727?mt=8) |
[Plusarium](https://itunes.apple.com/us/app/plusarium/id901280642?l=ru&ls=1&mt=8) |
[Naomuseum](https://itunes.apple.com/ru/app/naomuseum/id847290457?mt=8) | [Aerobia](https://itunes.apple.com/us/app/aerobia/id566375588?mt=8) | [StreetForm](https://itunes.apple.com/us/app/easy/id874395902?ls=1&mt=8)

## License

If you use DLImageLoader code in your application you should inform the author about it ( email: andrey.lunevich[at]gmail[dot]com ) like this:

>**Subject**: DLIL usage notification <br />
>**Text**: I use DLImageLoader in <application_name> - http://link_to_app_store. I [allow | don't >allow] to mention my app in section "Applications using DLImageLoader" on GitHub.

Also I'll be grateful if you mention DLIL in application UI with string "Using DLImageLoader (c) 2013-2014, Andrey Lunevich" (e.g. in some "About" section).

    Copyright 2013-2014 Andrey Lunevich

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
