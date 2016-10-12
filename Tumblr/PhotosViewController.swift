//
//  ViewController.swift
//  Tumblr
//
//  Created by Mary Martinez on 10/11/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    let refreshControl = UIRefreshControl()
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the table view
        tableView.rowHeight = 320
        
        // get the data
        fetchData(shouldRefresh: false)
        
        // init refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.fetchData(shouldRefresh: true)
    }
    
    func fetchData(shouldRefresh: Bool) {
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            
            self.parseData(response: dataOrNil, shouldRefresh: shouldRefresh)
            
        });
        task.resume()
    }
    
    func parseData(response: Data?, shouldRefresh: Bool) {
        if let data = response {
            let json = JSON(data: data)
            if let postsArray = json["response"]["posts"].array {
                
                // get data for each post
                for post in postsArray {
                    
                    let postDate = post["date"].string
                    let postImage = post["photos"][0]["original_size"]["url"].URL
                    
                    guard let date = postDate else {
                        continue
                    }
                    guard let imagePath = postImage else {
                        continue
                    }
                    
                    let dateString = self.formatDate(dateString: date)
                    let currPost = Post(date: dateString, imagePath: imagePath)
                    
                    self.posts.append(currPost)
                    NSLog("post: \(currPost.date) \(currPost.imagePath)")
                }
                
                self.tableView.reloadData()
                
                if shouldRefresh {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    // Prettifies the date from json response
    func formatDate(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.isLenient = true

        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = "EEE, MMM dd YYYY"
        
        let dateObj = dateFormatter.date(from: dateString)
        let result = resultFormatter.string(from: dateObj!)
        
        return result
    }
    
    // MARK: TableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.codepath.PhotoCell") as! PhotoCell
        cell.photo.setImageWith(posts[indexPath.section].imagePath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        headerView.contentView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // set the avatar
        profileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here

        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        vc.post = posts[(indexPath?.row)!]
    }
}
