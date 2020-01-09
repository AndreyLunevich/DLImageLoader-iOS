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

public final class DLImageLoader {

    public typealias Result = (_ result: Swift.Result<UIImage, DLImageLoader.Error>) -> Void

    public enum Error: Swift.Error {
        case invalidUrl
        case loadingFailed(Swift.Error)
        case corruptedImage
    }

    public var enableLog = false

    /**
     Instance method
     - returns: DLImageLoader instance.
     */
    public static let shared = DLImageLoader()

    private let session: URLSession
    private var cache: CacheManager?

    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: nil,
                             delegateQueue: OperationQueue.main)

        do {
            setupCache(try CacheManager())
        } catch {
            log(message: error.localizedDescription)
        }
    }

    @discardableResult
    public func setupCache(_ cache: CacheManager) -> Self {
        self.cache?.clear()

        self.cache = cache

        return self
    }

    /**
     Load image from url
     - parameter url: The url of image.
     - parameter into: UIImageView in which will display image.
     - parameter completion: Completion block that will be called after image loading.
     */
    @discardableResult
    public func load(_ url: URL?,
                     placeholder: UIImage? = nil,
                     into imageView: UIImageView,
                     apply transformations: [Transformation] = [],
                     cacheStrategy: CacheStrategy = .tranformed(key: nil),
                     completion: Result? = nil) -> URLSessionDataTask? {
        imageView.image = placeholder

        guard let url = url else {
            completion?(.failure(.invalidUrl))

            return nil
        }

        return load(URLRequest(url: url),
                    into: imageView,
                    apply: transformations,
                    cacheStrategy: cacheStrategy,
                    completion: completion)
    }

    /**
     Load image from request
     - parameter request: The request of image.
     - parameter into: UIImageView in which will display image.
     - parameter completion: Completion block that will be called after image loading.
     */
    @discardableResult
    public func load(_ request: URLRequest,
                     placeholder: UIImage? = nil,
                     into imageView: UIImageView,
                     apply transformations: [Transformation] = [],
                     cacheStrategy: CacheStrategy = .tranformed(key: nil),
                     completion: Result? = nil) -> URLSessionDataTask? {
        imageView.image = placeholder

        return load(request, apply: transformations, cacheStrategy: cacheStrategy) { result in
            switch result {
            case .success(let image):
                if let completion = completion {
                    completion(.success(image))
                } else {
                    imageView.image = image
                    imageView.setNeedsDisplay()
                }

            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    /**
     Load image from url
     - parameter url: The url of image.
     - parameter completion: Completion block that will be called after image loading.
     */
    @discardableResult
    public func load(_ url: URL?,
                     apply transformations: [Transformation] = [],
                     cacheStrategy: CacheStrategy = .tranformed(key: nil),
                     completion: Result? = nil) -> URLSessionDataTask? {
        guard let url = url else {
            completion?(.failure(.invalidUrl))

            return nil
        }

        return load(URLRequest(url: url),
                    apply: transformations,
                    cacheStrategy: cacheStrategy,
                    completion: completion)
    }

    /**
     Load image from request
     - parameter request: The request of image.
     - parameter completion: Completion block that will be called after image loading.
     */
    @discardableResult
    public func load(_ request: URLRequest,
                     apply transformations: [Transformation] = [],
                     cacheStrategy: CacheStrategy = .tranformed(key: nil),
                     completion: Result? = nil) -> URLSessionDataTask? {
        guard let url = request.url?.absoluteString, !url.isEmpty else {
            completion?(.failure(.invalidUrl))

            return nil
        }

        log(message: "loading image from url => \(url)")

        if let image = try? image(for: cacheStrategy, url: url) {
            log(message: "got an image from the cache")

            completion?(.success(image))

            return nil
        }

        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                completion?(.failure(.loadingFailed(error)))

                self?.log(message: "error image loading \(error)")
            } else {
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.global(qos: .userInitiated).async {
                        var result = image
                        for transformation in transformations {
                            result = transformation.transform(result)
                        }

                        // save loaded image to cache
                        try? self?.saveImage(original: image, transformed: result, strategy: cacheStrategy, url: url)

                        DispatchQueue.main.async {
                            completion?(.success(result))

                            self?.log(message: "loaded image from url => \(url)")
                        }
                    }
                } else {
                    completion?(.failure(.corruptedImage))
                }
            }
        }

        task.resume()

        return task
    }

    /**
     Cancel task
     - parameter url: Url to stop a task
     */
    public func cancelOperation(url: URL?) {
        allTasks(of: session) { tasks in
            for task in tasks where task.currentRequest?.url == url {
                task.cancel()
            }
        }
    }

    /**
     Stop all active tasks
     */
    public func cancelAllOperations() {
        allTasks(of: session) { tasks in
            for task in tasks {
                task.cancel()
            }
        }
    }

    /**
     Clear cache of DLImageLoader
     */
    public func clearCache(_ completion: ((_ error: Swift.Error?) -> Void)? = nil) {
        cache?.clear(completion)
    }


    // MARK: Private Methods

    private func image(for strategy: CacheStrategy, url: String) throws -> UIImage? {
        var image: UIImage?

        switch strategy {
        case .original(let key), .tranformed(let key):
            image = try cache?.image(forKey: key ?? url)

        case .both(let original, let tranformed):
            image = try cache?.image(forKey: original ?? url)

            if image == nil {
                image = try cache?.image(forKey: tranformed ?? url)
            }
        }

        return image
    }

    private func saveImage(original: UIImage, transformed: UIImage, strategy: CacheStrategy, url: String) throws {
        switch strategy {
        case .original(let key):
            try cache?.saveImage(original, forKey: key ?? url)

        case .tranformed(let key):
            try cache?.saveImage(transformed, forKey: key ?? "\(url)+transformed")

        case .both(let originalKey, let tranformedKey):
            try cache?.saveImage(original, forKey: originalKey ?? url)

            try cache?.saveImage(transformed, forKey: tranformedKey ?? "\(url)+transformed")
        }
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
