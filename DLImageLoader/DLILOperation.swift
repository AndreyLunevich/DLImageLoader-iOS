//
//  DLILOperation.swift
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

typealias CompletionBlock = (error: NSError?, image: UIImage?) -> ()
typealias CancelBlock = () -> ()

class DLILOperation: NSOperation, NSURLSessionDataDelegate {
    
    var completed: CompletionBlock?
    var canceled: CancelBlock?
    var data: NSMutableData = NSMutableData()
    var connection: NSURLSessionTask! = nil
    var request: NSURLRequest! = nil
    
    override func cancel()
    {
        self.connection.cancel()
        self.connection = nil
        self.data.setData(NSData(bytes: nil, length: 0))
        self.canceled?()
    }
    
    internal func url() -> String {
        return self.request.URL!.absoluteString
    }
    
    internal func startLoading(request: NSURLRequest, completed: CompletionBlock?, canceled: CancelBlock?)
    {
        self.request = request
        if url().characters.count == 0 {
            completed?(error: nil, image: nil) // fail loading
        } else {
            self.completed = completed
            self.canceled = canceled
            let connection = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
            self.connection = connection.dataTaskWithRequest(request)
            self.connection.resume()
            if self.connection == nil {
                cancel()
            }
        }
    }
    
    /**
     * pragma mark - NSURLSessionDataDelegate
     */

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData)
    {
        self.data.appendData(data)
    }

    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?)
    {
        // fail loading
        if (error != nil) {
            self.completed?(error: nil, image: nil)
        }
        // successfull loading
        self.completed?(error: nil, image: UIImage(data: self.data))
    }
}
