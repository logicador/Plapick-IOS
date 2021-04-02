//
//  EditPostsImage.swift
//  Plapick
//
//  Created by 서원영 on 2021/03/26.
//

import UIKit


class EditPostsImage {
    var image: UIImage? = nil
    var postsImage: PostsImage? = nil
    
    init(image: UIImage? = nil, postsImage: PostsImage? = nil) {
        self.image = image
        self.postsImage = postsImage
    }
}
