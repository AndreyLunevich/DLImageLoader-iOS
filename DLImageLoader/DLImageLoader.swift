//
//  DLILManager.swift
//
//  Created by Andrey Lunevich
//  Copyright © 2015 Andrey Lunevich. All rights reserved.

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit

public class DLImageLoader: NSObject {
    
    var queue: NSOperationQueue = NSOperationQueue();
    
    /**
     Instance method
     @return shared instance.
    */
    public static let sharedInstance = DLImageLoader()
    
    private func updateImageView(imageView: UIImageView, image: UIImage?)
    {
        imageView.image = image
        imageView.setNeedsDisplay()
    }
    
    private func dlog(message:String, function:String = __FUNCTION__, file:String = __FILE__)
    {
        /***** Will only print in Debug mode. *****/
        /* For this to work, add the "-D DEBUG" flag to the "Swift Compiler - Custom Flags" to Debug mode, under Build Settings.  */
        #if DEBUG
            println("SSLogger: Original_Message = \(message)\n Method_Name = \(function)\n File_Name = \(file.lastPathComponent)");
        #endif
    }
    
    /**
     Load image from url
     @param url The url of image.
     @param completed Completed is a completion block that will call after image loading.
    */
    public func loadImageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->()))
    {
        loadImageFromUrl(url, completed: completed, canceled: nil)
    }
    
    /**
     Load image from url
     @param url The url of image.
     @param completed Completed is a completion block that will call after image loading.
     @param canceled Canceled is a block that will if loading opedation was calceled.
    */
    public func loadImageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->())? = nil, canceled:(() -> ())? = nil)
    {
        let image = DLILCacheManager.sharedInstance.imageByKey(url)
        if (image != nil) {
            
            dlog("=======")
            dlog("DLImageLoader: got an image from the cache")
            dlog("DLImageLoader: url of the image => %@", function: url)
            dlog("=======")
            
            if (completed != nil) {
                completed!(error: nil, image: image);
            }
        } else {
            dlog("DLImageLoader: start image loading from url => %@", function: url);
            
            let operation:DLILOperation = DLILOperation()
            operation.startLoadingWithUrl(url, completed: { (error, image) -> () in
                
                self.dlog("=======")
                self.dlog("DLImageLoader: loading completed")
                self.dlog("DLImageLoader: url of loaded image => %@", function: url)
                self.dlog("=======")
                
                // save loaded image to cache
                DLILCacheManager.sharedInstance.saveImage(image!, forKey: url)
                if (completed != nil) {
                    completed!(error: error, image: image);
                }
                }, canceled: { () -> () in
                    self.dlog("DLImageLoader: image loading is canceled")
                    
                    if (canceled != nil) {
                        canceled!();
                    }
            })
            self.queue.addOperation(operation)
        }
    }
    
    /**
     Load image from url
     @param url The url of image.
     @param imageView UIImageView in which will display image.
    */
    public func displayImageFromUrl(url: String, imageView: UIImageView)
    {
        imageView.image = nil;
        loadImageFromUrl(url, completed: { (error, image) -> () in
            self.updateImageView(imageView, image: image)
            }) { () -> () in
                self.updateImageView(imageView, image: nil)
        }
    }
    
    /**
     Cancel operation
     @param url. Url of operation to stop
    */
    public func cancelOperation(url: String!)
    {
        for operation in self.queue.operations {
            if let dlil = operation as? DLILOperation {
                if (dlil.url == url) {
                    dlil.cancel()
                }
            }
        }
    }
    
    /**
     Stop all active operations
    */
    public func cancelAllOperations()
    {
        for operation in self.queue.operations {
            operation.cancel()
        }
    }
    
    /**
     Clear cache of DLImageLoader
    */
    public func clearCache()
    {
        DLILCacheManager.sharedInstance.clear();
    }
}