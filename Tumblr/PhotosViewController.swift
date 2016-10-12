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
                if let postsArray = json["response"]["posts"].array {
                    
                    // get data for each post
                    for post in postsArray {
                        
                        let postDate = post["date"].string
                        let postImage = post["image_permalink"].URL

                        guard let date = postDate else {
                            continue
                        }
                        guard let imagePath = postImage else {
                            continue
                        }
                        
                        let dateString = self.formatDate(dateString: date)
                        let currPost = Post(date: dateString, imagePath: imagePath)
                        
                        self.post.append(currPost)
                        NSLog("post: \(currPost.date) \(currPost.imagePath)")
                    }
                    
                }
            }
        });
        task.resume()
    }
    
    func formatDate(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.isLenient = true

        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = "MM-dd-yyyy"
        
        let dateObj = dateFormatter.date(from: dateString)
        let result = resultFormatter.string(from: dateObj!)
        
        return result
    }
}
