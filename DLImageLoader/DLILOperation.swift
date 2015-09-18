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

class DLILOperation: NSOperation, NSURLConnectionDelegate {
    
    typealias CompletionBlock = (error: NSError?, image: UIImage?) -> ()
    typealias CancelBlock = () -> ()
    
    var completed: CompletionBlock! = nil;
    var canceled: CancelBlock! = nil;
    var data: NSMutableData = NSMutableData();
    var connection: NSURLConnection! = nil;
    internal var url: String = ""
    
    override func cancel()
    {
        self.connection.cancel();
        self.connection = nil;
        self.data.setData(NSData(bytes: nil, length: 0))
        if (self.canceled != nil) {
            self.canceled();
        }
    }
    
    internal func startLoadingWithUrl(url: String, completed: CompletionBlock!, canceled: CancelBlock!)
    {
        self.url = url;
        if (self.url.characters.count == 0) {
            // fail loading
            if (completed != nil) {
                completed(error: nil, image: nil);
            }
            return;
        }
        
        self.completed = completed;
        self.canceled = canceled;
        
        let request = NSURLRequest(URL: NSURL(string: self.url)!)
        self.connection = NSURLConnection(request: request, delegate: self)
        if (self.connection == nil) {
            cancel();
        }
    }
    
    /**
     pragma mark - NSURLConnectionDataDelegate
    */
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        // successfull loading
        if (self.completed != nil) {
            self.completed(error: nil, image: UIImage(data: self.data));
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        // fail loading
        if (self.completed != nil) {
            self.completed(error: nil, image: nil);
        }
    }
}