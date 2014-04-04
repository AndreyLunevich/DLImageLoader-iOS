DLImageLoader-iOS
=================

Image Loader for ios (downloading and caching images).

// ===  Sample of using DLImageLoader  === //

>Connect DLImageLoader in your .m file:

<pre>
#import "DLImageLoader.h"
</pre>

>After that, call image loading:

<pre>
[DLImageLoader loadImageFromURL:@"image_url_here"
                      completed:^(NSError *error, NSData *imgData) {
                      	if (error == nil) {
                      		// if we have no errors
                      	} else {
                      		// if we got error when load image
                        }
                    }];
</pre>

// === Sample is in DLImageLoader Demo == //

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
