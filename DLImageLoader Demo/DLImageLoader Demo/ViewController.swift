//
//  ViewController.swift
//  DLImageLoader Demo
//
//  Created by Andrew Lunevich on 9/15/15.
//  Copyright © 2015 Andrew Lunevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: DLImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.imageView.displayImageFromUrl("http://lialka.net/Content/images/1.jpg")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}