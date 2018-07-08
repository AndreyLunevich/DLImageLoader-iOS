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

    private(set) var url: String? = ""

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    /**
     Load image from url
     - parameter url: The url of image.
     - parameter completed: Completion block that will be called after image loading.
     */
    public func image(for url: String, completed: DLILCompletion? = nil) {
        guard let url = URL(string: url) else {
            completed?(nil, nil)

            return
        }

        image(for: URLRequest(url: url), completed: completed)
    }

    /**
     Load image from request
     - parameter request: The request of image.
     - parameter completed: Completion block that will be called after image loading.
     */
    public func image(for request: URLRequest, completed: DLILCompletion? = nil) {
        self.url = request.url?.absoluteString
        self.image = nil

        DLImageLoader.shared.image(for: request, completed: { [weak self] (image, error) in
            if let completion = completed {
                completion(image, error)
            } else {
                self?.image = image
            }
        })
    }

    /**
     Cancel started operation
     */
    public func cancelLoading() {
        DLImageLoader.shared.cancelOperation(url: self.url)
    }


    // MARK: - private methods

    private func configureView() {
        self.contentMode = UIViewContentMode.scaleAspectFit
    }
}
