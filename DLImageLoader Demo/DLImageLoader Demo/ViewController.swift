//
//  ViewController.swift
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 9/15/15.
//  Copyright © 2015 Andrew Lunevich. All rights reserved.
//

import UIKit
import DLImageLoader

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    private var task: URLSessionDataTask?

    deinit {
        task?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshDidPress(self)
    }

    @IBAction func clearDidPress(_ sender: Any) {
        DLImageLoader.shared.clearCache()
    }

    @IBAction func refreshDidPress(_ sender: Any) {
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Swift_logo.svg/2000px-Swift_logo.svg.png")

        task = DLImageLoader.shared.load(url, into: imageView)
    }
}
