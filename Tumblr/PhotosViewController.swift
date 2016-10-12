//
//  ViewController.swift
//  Tumblr
//
//  Created by Mary Martinez on 10/11/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotosViewController: UIViewController {

    var post = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }

    func fetchData() {
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            
            if let data = dataOrNil {
                let json = JSON(data: data)
                let postsDictionary = json["response"]["posts"]
                NSLog("response: \(postsDictionary)")
            }
        });
        task.resume()
    }
}

class Post {
    var blog_name: String
    var id: Int
    var type: String
    var date: Date
    var summary: String
    var caption: String
    var imagePath: URL?
    
    init(name: String, id: Int, type: String, date: Date, summary: String, caption: String, imagePath: URL?) {
        
        self.blog_name = name
        self.id = id
        self.type = type
        self.date = date
        self.summary = summary
        self.caption = caption
    }
}
