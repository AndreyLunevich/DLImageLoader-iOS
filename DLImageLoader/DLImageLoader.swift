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

public typealias DLILCompletion = (_ image: UIImage?, _ error: Error?) ->()

public class DLImageLoader {

    private var session: URLSession

    public var enableLog = false

    /**
     Instance method
     - returns: DLImageLoader instance.
     */
    public static let shared = DLImageLoader()

    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: nil,
                             delegateQueue: OperationQueue.main)
    }

    /**
     Load image from url
     - parameter url: The url of image.
     - parameter imageView: UIImageView in which will display image.
     */
    public func image(from url: URL?, into imageView: UIImageView) {
        guard let url = url else { return }

        image(for: URLRequest(url: url), imageView: imageView)
    }

    /**
     Load image from url
     - parameter url: The url of image.
     - parameter completed: Completion block that will be called after image loading.
     - parameter canceled: Cancellation block that will be called if loading was canceled.
     */
    public func image(for url: URL?, completed: DLILCompletion? = nil) {
        guard let url = url else { return }

        image(for: URLRequest(url: url), completed: completed)
    }

    /**
     Load image from request
     - parameter request: The request of image.
     - parameter imageView: UIImageView in which will display image.
     */
    public func image(for request: URLRequest, imageView: UIImageView) {
        imageView.image = nil

        image(for: request) { [weak self] (image, _) in
            self?.updateImageView(imageView, image: image)
        }
    }

    /**
     Load image from request
     - parameter request: The request of image.
     - parameter completed: Completion block that will be called after image loading.
     - parameter canceled: Cancellation block that will be called if loading was canceled.
     */
    public func image(for request: URLRequest, completed: DLILCompletion? = nil) {
        guard let url = request.url?.absoluteString, url.count > 0 else {
            completed?(nil, nil) // fail loading

            return
        }

        log(message: "loading image from url => \(url)")

        if let image = DLILCacheManager.shared.imageByKey(key: url) {
            log(message: "got an image from the cache")

            completed?(image, nil)
        } else {
            let task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                var image: UIImage?

                if let error = error {
                    self?.log(message: "error image loading \(error)")
                } else if let data = data {
                    image = UIImage(data: data)

                    // save loaded image to cache
                    DLILCacheManager.shared.saveImage(image: image, forKey: url)

                    self?.log(message: "loaded image from url => \(url)")
                }

                completed?(image, error)
            })

            task.resume()
        }
    }

    /**
     Cancel task
     - parameter url: Url to stop a task
     */
    public func cancelOperation(url: String!) {
        allTasks(of: session) { (tasks) in
            for task in tasks {
                if task.currentRequest?.url?.absoluteString == url {
                    task.cancel()
                }
            }
        }
    }

    /**
     Stop all active tasks
     */
    public func cancelAllOperations() {
        allTasks(of: session) { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
    }

    /**
     Clear cache of DLImageLoader
     */
    public func clearCache(completed:((_ success: Bool) ->())?) {
        DLILCacheManager.shared.clear(completed: completed)
    }


    // MARK: - private methods

    private func updateImageView(_ imageView: UIImageView, image: UIImage?) {
        imageView.image = image
        imageView.setNeedsDisplay()
    }

    private func allTasks(of session: URLSession, completionHandler: @escaping ([URLSessionTask]) -> Void) {
        session.getTasksWithCompletionHandler { (data, upload, download) in
            let tasks = data as [URLSessionTask] + upload as [URLSessionTask] + download as [URLSessionTask]

            completionHandler(tasks)
        }
    }

    private func log(message: String) {
        if enableLog {
            print("DLImageLoader: \(message)")
        }
    }
}
