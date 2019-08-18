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

    private var cache = NSCache<NSString, UIImage>()

    /**
     Memory cache, memoryCacheEnabled by default is true
     */
    internal var memoryCacheEnabled = true

    /**
     Disk cache, diskCacheEnabled by default is true
     */
    internal var diskCacheEnabled = true

    /**
     DLILCacheManager instance
     */
    internal static let shared = DLILCacheManager()

    override init() {
        super.init()
        do {
            let path = cacheDirectoryPath()
            var isDir: ObjCBool = false
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    /**
     Get the image from the cache by the key (image url).
     At first will try to get image from memory cache
     If image will not found, will try to get image from disk cache
     - parameter key: Url of image that using as cache key.
     */
    internal func image(forKey key: String) -> UIImage? {
        var image: UIImage? = nil

        if memoryCacheEnabled {
            image = cache.object(forKey: key as NSString)
        }

        if image == nil {
            if diskCacheEnabled {
                image = imageFromDisk(key: key)
            }
        }

        return image
    }

    /**
     Save the image in the cache for the key (image url).
     - parameter image: UIImage to save in cache.
     - parameter key: Url of image that using as cache key
     */
    internal func saveImage(image: UIImage?, forKey key: String) {
        if memoryCacheEnabled {
            DispatchQueue.global(qos: .background).async {
                if let image = image {
                    self.cache.setObject(image, forKey: key as NSString)
                }
            }
        }

        if diskCacheEnabled {
            DispatchQueue.global(qos: .background).async {
                if let image = image {
                    self.saveImageToDisk(image: image, withKey: key)
                }
            }
        }
    }

    /**
     Clear memory and disk cache
     */
    internal func clear(completed:((_ success: Bool) ->())?) {
        DispatchQueue.global(qos: .background).async {
            var success: Bool = true
            self.cache.removeAllObjects()
            let fileManager = FileManager.default
            let directory = self.cacheDirectoryPath()
            do {
                let files = try fileManager.contentsOfDirectory(atPath: directory)
                for file in files {
                    let path = self.getOrCreatePathToImageWithKey(key: file)
                    do {
                        try fileManager.removeItem(atPath: path)
                    } catch {
                        success = false
                    }
                }
            } catch {
                success = false
            }

            DispatchQueue.main.async {
                completed?(success)
            }
        }
    }


    // MARK: - private methods

    private func saveImageToDisk(image :UIImage, withKey: String) {
        let path = getOrCreatePathToImageWithKey(key: withKey)
        let data = image.pngData()

        do {
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
        }
    }

    private func imageFromDisk(key: String) -> UIImage? {
        let path = getOrCreatePathToImageWithKey(key: key)

        return UIImage(contentsOfFile: path)
    }

    private func getOrCreatePathToImageWithKey(key: String) -> String {
        let imageName = key.replacingOccurrences(of: "/", with: "_")
        let path = (cacheDirectoryPath() as NSString).appendingPathComponent(imageName)

        // create file if not exist
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }

        return path
    }

    private func cacheDirectoryPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString

        return path.appendingPathComponent(kCacheFolderName)
    }
}
