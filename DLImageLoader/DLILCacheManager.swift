//
//  DLILCacheManager.swift
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

class DLILCacheManager: NSObject {
    
    private let kCacheFolderName = "DLILCacheFolder"
    
    var cache: NSCache = NSCache()
    
    /**
     * Memory cache
     * @param memoryCacheEnabled by default is true
     */
    internal var memoryCacheEnabled = true
    
    /**
     * Disk cache
     * @param diskCacheEnabled by default is true
     */
    internal var diskCacheEnabled = true
    
    /**
     * DLILCacheManager instance
     */
    internal static let sharedInstance = DLILCacheManager()
    
    override init() {
        super.init()
        do {
            var isDir: ObjCBool = false
            let fileManager = NSFileManager.defaultManager()
            if !fileManager.fileExistsAtPath(self.cacheDirectoryPath(), isDirectory: &isDir) {
                try fileManager.createDirectoryAtPath(self.cacheDirectoryPath(), withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    /**
     * Get the image from the cache by the key.
     * At first will try to get image from memory cache
     * If image will not found, will try to get image from disk cache
     * @param key. Key of image in cache.
     */
    internal func imageByKey(key: String) -> UIImage?
    {
        var image: UIImage? = nil
        if self.memoryCacheEnabled {
            image = self.cache.objectForKey(key) as? UIImage
        }
        if image == nil {
            if self.diskCacheEnabled {
                image = self.imageFromDisk(key)
            }
        }
        
        return image
    }
    
    /**
     * Save the image in the cache for the key.
     * @param image. UIImage to save in cache.
     * @param key. Key of image in cache.
     */
    internal func saveImage(image: UIImage?, forKey: String)
    {
        if self.memoryCacheEnabled {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                if image != nil {
                    self.cache.setObject(image!, forKey: forKey)
                }
            }
        }
        if self.diskCacheEnabled {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                if image != nil {
                    self.saveImageToDisk(image!, withKey: forKey)
                }
            }
        }
    }
    
    private func saveImageToDisk(image :UIImage, withKey: String)
    {
        let path = self.pathToImageWithKey(withKey)
        let data = UIImagePNGRepresentation(image)
        data?.writeToFile(path, atomically: true)
    }
    
    private func imageFromDisk(key: String) -> UIImage?
    {
        let path = self.pathToImageWithKey(key)
        return UIImage(contentsOfFile: path)
    }
    
    private func pathToImageWithKey(key: String) -> String
    {
        let fileManager = NSFileManager.defaultManager()
        var path = self.cacheDirectoryPath()
        let array = key.componentsSeparatedByString(":/")
        for i in 0..<array.count {
            let s = array[i]
            if s.characters.count == 0 {
                continue
            }
            path = path.stringByAppendingString(s)
            if i != array.count - 1 && !fileManager.fileExistsAtPath(path) {
                do {
                    try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
                } catch let error as NSError {
                    print(error.description)
                }
            }
        }
        
        return path
    }
    
    private func cacheDirectoryPath() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as NSString
        return path.stringByAppendingPathComponent(kCacheFolderName)
    }
    
    /**
     * Clear memory and disk cache
     */
    internal func clear(completed:((success: Bool) ->())?)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var success: Bool = true
            self.cache.removeAllObjects()
            let fileManager = NSFileManager.defaultManager()
            let directory = self.cacheDirectoryPath()
            do {
                let files = try fileManager.contentsOfDirectoryAtPath(directory)
                for file in files {
                    let path = directory.stringByAppendingString(file)
                    do {
                        try fileManager.removeItemAtPath(path)
                    } catch {
                        success = false
                    }
                }
            } catch {
                success = false
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completed?(success: success)
            })
        }
    }
}
