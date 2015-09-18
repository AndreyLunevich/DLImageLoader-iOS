DLImageLoader-Swift
=================

## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add DLImageLoader to your project.

1. Add a pod entry for DLImageLoader to your Podfile `pod 'DLImageLoader', '1.0.0-swift'`
2. Install the pod(s) by running `pod install`.

### Source files

Alternatively you can directly add the `DLImageLoader` folder to your project.

1. Download the latest code version or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `DLImageLoader` folder onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 

## Usage

### Simple

<pre>
DLImageLoader.sharedInstance.displayImageFromUrl("image_url_here", imageView: "UIImageView here")
</pre>

### Complete

<pre>
DLImageLoader.sharedInstance.loadImageFromUrl("image_url_here") { (error, image) -> () in
    if (error == nil) {
        // if we have no any errors
    } else {
        // if we got an error when load an image
    }
}
</pre>
<pre>
DLImageLoader.sharedInstance.loadImageFromUrl("image_url_here", completed: { (error, image) -> () in
    if (error == nil) {
        // if we have no any errors
    } else {
        // if we got an error when load an image
    }
}) { () -> () in
    // image loading was canceled
}
</pre>
### Cancel loading operations

// === With using of DLImageLoader instance === //

<pre>
DLImageLoader.sharedInstance.cancelOperation("image_url_here")
</pre>

<pre>
DLImageLoader.sharedInstance.cancelAllOperations()
</pre>

// === With using of DLImageView === //

<pre>
DLImageView.cancelLoading()
</pre>