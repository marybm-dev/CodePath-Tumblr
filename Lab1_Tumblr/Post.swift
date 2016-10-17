//
//  Post.swift
//  Tumblr
//
//  Created by Mary Martinez on 10/11/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation

class Post {

    var date: String
    var imagePath: URL
    
    init(date: String, imagePath: URL) {
        self.date = date
        self.imagePath = imagePath
    }
}
