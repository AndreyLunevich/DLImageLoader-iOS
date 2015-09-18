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

class DLImageView: UIImageView {

    var url: String? = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override func awakeFromNib() {
        configureView()
    }
    
    private func configureView()
    {
        self.contentMode = UIViewContentMode.ScaleAspectFit
    }

    /**
     Display image from url
     @param urlString The url of image.
    */
    internal func displayImageFromUrl(url: String)
    {
        loadImageFromUrl(url) { (error, image) -> () in
            self.image = image
        }
    }
    
    /**
     Load image from url
     @param urlString The url of image.
     @param completed Completed is a completion block that will call after image loading.
    */
    internal func loadImageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->())? = nil)
    {
        self.url = url;
        self.image = nil;
        DLImageLoader.sharedInstance.loadImageFromUrl(url, completed: completed)
    }
    
    /**
     Cancel started operation
    */
    internal func cancelLoading()
    {
        DLImageLoader.sharedInstance.cancelOperation(self.url)
    }
}