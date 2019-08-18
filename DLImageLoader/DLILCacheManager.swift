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

public final class DLILCacheManager {

    public static var cacheDirectoryPath: String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString

        return path.appendingPathComponent("DLILCacheFolder")
    }

    public enum Location {
        case memory
        case disk(path: String)
    }

    private let locations: [Location]
    private let cache = NSCache<NSString, UIImage>()

    public init(locations: [Location] = [.memory, .disk(path: DLILCacheManager.cacheDirectoryPath)]) throws {
        precondition(!locations.isEmpty, "DLILCacheManager locations couldn't be empty")

        self.locations = locations

        if case .disk(let path)? = locations.disk {
            var isDir: ObjCBool = false
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            }
        }
    }

    /**
     Get the image from the cache by the key (image url).
     At first will try to get image from memory cache
     If image will not found, will try to get image from disk cache
     - parameter key: Url of image that using as cache key.
     */
    internal func image(forKey key: String) -> UIImage? {
        var image: UIImage?

        if locations.memory != nil {
            image = cache.object(forKey: key as NSString)
        }

        if image == nil, case .disk(let path)? = locations.disk {
            image = UIImage(contentsOfFile: imagePath(base: path, key: key))
        }

        return image
    }

    /**
     Save the image in the cache for the key (image url).
     - parameter image: UIImage to save in cache.
     - parameter key: Url of image that using as cache key
     */
    internal func saveImage(_ image: UIImage, forKey key: String) {
        DispatchQueue.global(qos: .background).async {
            if self.locations.memory != nil {
                self.cache.setObject(image, forKey: key as NSString)
            }

            if case .disk(let path)? = self.locations.disk {
                try? self.saveImage(image, byPath: self.imagePath(base: path, key: key))
            }
        }
    }

    /**
     Clear memory and disk cache
     */
    internal func clear(_ completion: ((_ success: Bool) -> Void)? = nil) {
        cache.removeAllObjects()

        DispatchQueue.global(qos: .background).async {
            var success: Bool = true

            if case .disk(let path)? = self.locations.disk {
                let fileManager = FileManager.default

                do {
                    let files = try fileManager.contentsOfDirectory(atPath: path)
                    for file in files {
                        do {
                            try fileManager.removeItem(atPath: self.imagePath(base: path, key: file))
                        } catch {
                            success = false
                        }
                    }
                } catch {
                    success = false
                }
            }

            DispatchQueue.main.async {
                completion?(success)
            }
        }
    }

    // MARK: - private methods

    private func saveImage(_ image: UIImage, byPath path: String) throws {
        // create file if not exist
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }

        try image.pngData()?.write(to: URL(fileURLWithPath: path), options: .atomic)
    }

    private func imagePath(base: String, key: String) -> String {
        return (base as NSString).appendingPathComponent(key.replacingOccurrences(of: "/", with: "_"))
    }
}

fileprivate extension Array where Element == DLILCacheManager.Location {

    var memory: DLILCacheManager.Location? {
        return first(where: { if case .memory = $0 { return true }; return false })
    }

    var disk: DLILCacheManager.Location? {
        return first(where: { if case .disk = $0 { return true }; return false })
    }
}
