//
//  DLImageView.swift
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

public class DLImageView: UIImageView {

    private var request: URLRequest?

    /**
     Load image from url
     - parameter url: The url of image.
     - parameter completed: Completion block that will be called after image loading.
     */
    public func image(from url: URL?, completion: DLILCompletion? = nil) {
        guard let url = url else {
            completion?(.failure(.invalidUrl))

            return
        }

        image(from: URLRequest(url: url), completion: completion)
    }

    /**
     Load image from request
     - parameter request: The request of image.
     - parameter completed: Completion block that will be called after image loading.
     */
    public func image(from request: URLRequest, completion: DLILCompletion? = nil) {
        self.request = request

        DLImageLoader.shared.load(request, into: self, completion: completion)
    }

    /**
     Cancel started operation
     */
    public func cancelLoading() {
        DLImageLoader.shared.cancelOperation(url: request?.url?.absoluteString)
    }
}
