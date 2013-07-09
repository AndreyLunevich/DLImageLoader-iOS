DLImageLoader-iOS
=================

Image Loader for ios

// ===  Sample of using DLImageLoader  === //

[DLImageLoader loadImageFromURL:[item objectForKey:@"picture"]
                      completed:^(NSError *error, NSData *imgData) {
                      	if (error == nil) {
                      		// if we have no errors
                      	} else {
                      		// if we get some error when load image
                        }
                    }];