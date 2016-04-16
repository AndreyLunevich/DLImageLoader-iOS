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
    
    private var session: NSURLSession!
    
    public var enableLog = false
    
    /**
        Instance method
        - returns: DLImageLoader instance.
     */
    public static let sharedInstance = DLImageLoader()
    
    override init() {
        super.init()
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                    delegate: nil,
                                    delegateQueue: NSOperationQueue.mainQueue())
    }
    
    /**
        Load image from url
        - parameter url: The url of image.
        - parameter imageView: UIImageView in which will display image.
     */
    public func imageFromUrl(url: String, imageView: UIImageView)
    {
        let request = NSURLRequest(URL: NSURL(string: url)!)
        imageFromRequest(request, imageView: imageView)
    }
    
    /**
        Load image from url
        - parameter url: The url of image.
        - parameter completed: Completion block that will be called after image loading.
     */
    public func imageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->()))
    {
        imageFromUrl(url, completed: completed, canceled: nil)
    }
    
    /**
        Load image from url
        - parameter url: The url of image.
        - parameter completed: Completion block that will be called after image loading.
        - parameter canceled: Cancellation block that will be called if loading was canceled.
     */
    public func imageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->())? = nil, canceled:(() -> ())? = nil)
    {
        let request = NSURLRequest(URL: NSURL(string: url)!)
        imageFromRequest(request, completed: completed, canceled: canceled)
    }
    
    /**
        Load image from request
        - parameter request: The request of image.
        - parameter imageView: UIImageView in which will display image.
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
        Load image from request
        - parameter request: The request of image.
        - parameter completed: Completion block that will be called after image loading.
     */
    public func imageFromRequest(request: NSURLRequest, completed:((error :NSError!, image: UIImage!) ->()))
    {
        imageFromRequest(request, completed: completed, canceled: nil)
    }
    
    /**
        Load image from request
        - parameter request: The request of image.
        - parameter completed: Completion block that will be called after image loading.
        - parameter canceled: Cancellation block that will be called if loading was canceled.
     */
    public func imageFromRequest(request: NSURLRequest,
                                 completed:((error :NSError!, image: UIImage!) ->())? = nil,
                                 canceled:(() -> ())? = nil)
    {
        if let url = request.URL?.absoluteString {
            let image = DLILCacheManager.sharedInstance.imageByKey(url)
            self.printLog("loading image from url => \(url)")
            
            if image != nil {
                self.printLog("got an image from the cache")
                completed?(error: nil, image: image)
            } else {
                if url.characters.count == 0 {
                    completed?(error: nil, image: nil) // fail loading
                } else {
                    let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                        if error != nil && error!.code == NSURLErrorCancelled {
                            canceled?()
                            
                            self.printLog("cancelled loading image from url \(url)")
                        } else {
                            let image = data != nil ? UIImage(data: data!) : nil
                            
                            if error != nil {
                                self.printLog("error image loading \(error)")
                            } else {
                                // save loaded image to cache
                                DLILCacheManager.sharedInstance.saveImage(image, forKey: url)
                                
                                self.printLog("loaded image from url => \(url)")
                            }
                            
                            completed?(error: error, image: image)
                        }
                    })
                    task.resume()
                }
            }
        } else {
            completed?(error: nil, image: nil) // fail loading
        }
    }
    
    /**
        Cancel task
        - parameter url: Url to stop a task
     */
    public func cancelOperation(url: String!)
    {
        allTasksOfSession(self.session) { (tasks) in
            for task in tasks {
                if task.currentRequest?.URL?.absoluteString == url {
                    task.cancel()
                }
            }
        }
    }
    
    /**
        Stop all active tasks
     */
    public func cancelAllOperations()
    {
        allTasksOfSession(self.session) { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
    }
    
    /**
        Clear cache of DLImageLoader
     */
    public func clearCache(completed:((success: Bool) ->())?)
    {
        DLILCacheManager.sharedInstance.clear(completed)
    }
    
    
    // MARK: - private methods
    
    private func updateImageView(imageView: UIImageView, image: UIImage?)
    {
        imageView.image = image
        imageView.setNeedsDisplay()
    }
    
    private func allTasksOfSession(session: NSURLSession,
                                   completionHandler: ([NSURLSessionTask]) -> Void)
    {
        session.getTasksWithCompletionHandler { (data, upload, download) in
            let tasks = data as [NSURLSessionTask] +
                upload as [NSURLSessionTask] +
                download as [NSURLSessionTask]
            completionHandler(tasks)
        }
    }
    
    private func printLog(message: String) {
        if self.enableLog {
            print("DLImageLoader: \(message)")
        }
    }
}
