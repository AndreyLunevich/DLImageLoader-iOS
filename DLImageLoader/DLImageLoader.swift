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

@objc protocol DLImageLoaderDelegate {
    
    optional func DLILLog(message: String)
}

public class DLImageLoader: NSObject {
    
    private var queue: NSOperationQueue = NSOperationQueue()
    var delegate: DLImageLoaderDelegate?
    
    /**
     * Instance method
     * @return shared instance.
     */
    public static let sharedInstance = DLImageLoader()
    
    private func updateImageView(imageView: UIImageView, image: UIImage?)
    {
        imageView.image = image
        imageView.setNeedsDisplay()
    }
    
    /**
     * Load image from url
     * @param url The url of image.
     * @param imageView UIImageView in which will display image.
     */
    public func imageFromUrl(url: String, imageView: UIImageView)
    {
        let request = NSURLRequest(URL: NSURL(string: url)!)
        imageFromRequest(request, imageView: imageView)
    }
    
    /**
     * Load image from url
     * @param url The url of image.
     * @param completed Completed is a completion block that will call after image loading.
     */
    public func imageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->()))
    {
        imageFromUrl(url, completed: completed, canceled: nil)
    }
    
    /**
     * Load image from url
     * @param url The url of image.
     * @param completed Completed is a completion block that will call after image loading.
     * @param canceled Canceled is a block that will if loading opedation was calceled.
     */
    public func imageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->())? = nil, canceled:(() -> ())? = nil)
    {
        let request = NSURLRequest(URL: NSURL(string: url)!)
        imageFromRequest(request, completed: completed, canceled: canceled)
    }
    
    /**
     * Load image from request
     * @param request The request of image.
     * @param imageView UIImageView in which will display image.
     */
    public func imageFromRequest(request: NSURLRequest, imageView: UIImageView)
    {
        imageView.image = nil
        imageFromRequest(request, completed: { (error, image) -> () in
            self.updateImageView(imageView, image: image)
        }) { () -> () in
            self.updateImageView(imageView, image: nil)
        }
    }
    
    /**
     * Load image from request
     * @param request The request of image.
     * @param completed Completed is a completion block that will call after image loading.
     */
    public func imageFromRequest(request: NSURLRequest, completed:((error :NSError!, image: UIImage!) ->()))
    {
        imageFromRequest(request, completed: completed, canceled: nil)
    }
    
    /**
     * Load image from request
     * @param request The request of image.
     * @param completed Completed is a completion block that will call after image loading.
     * @param canceled Canceled is a block that will if loading opedation was calceled.
     */
    public func imageFromRequest(request: NSURLRequest, completed:((error :NSError!, image: UIImage!) ->())? = nil, canceled:(() -> ())? = nil)
    {
        let url = request.URL!.absoluteString
        let image = DLILCacheManager.sharedInstance.imageByKey(url)
        self.delegate?.DLILLog!("DLImageLoader: image with url => \(url)")
        if image != nil {
            self.delegate?.DLILLog!("DLImageLoader: got an image from the cache")
            completed?(error: nil, image: image)
        } else {
            let operation:DLILOperation = DLILOperation()
            operation.startLoading(request, completed: { (error, image) -> () in
                if error != nil {
                    self.delegate?.DLILLog!("DLImageLoader: error of image loading => \(error)")
                } else {
                    self.delegate?.DLILLog!("DLImageLoader: loaded image with url => \(url)")
                }
                // save loaded image to cache
                DLILCacheManager.sharedInstance.saveImage(image, forKey: url)
                completed?(error: error, image: image)
            }, canceled: { () -> () in
                self.delegate?.DLILLog!("DLImageLoader: image loading is canceled")
                canceled?()
            })
            self.queue.addOperation(operation)
        }
    }
    
    /**
     * Cancel operation
     * @param url. Url of operation to stop
     */
    public func cancelOperation(url: String!)
    {
        for operation in self.queue.operations {
            if let dlil = operation as? DLILOperation {
                if dlil.url() == url {
                    dlil.cancel()
                }
            }
        }
    }
    
    /**
     * Stop all active operations
     */
    public func cancelAllOperations()
    {
        for operation in self.queue.operations {
            operation.cancel()
        }
    }
    
    /**
     * Clear cache of DLImageLoader
     */
    public func clearCache(completed:((success: Bool) ->())?)
    {
        DLILCacheManager.sharedInstance.clear(completed)
    }
}
