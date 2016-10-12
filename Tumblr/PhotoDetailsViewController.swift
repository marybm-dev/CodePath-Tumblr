//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Mary Martinez on 10/12/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.setImageWith(post.imagePath)
    }
}
