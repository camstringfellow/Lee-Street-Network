//
//  PostViewCell.swift
//  TheLeeStreetNetwork
//
//  Created by Cameron Stringfellow on 3/14/17.
//  Copyright © 2017 Stringfellow. All rights reserved.
//

import UIKit
import Firebase

class PostViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    //variable of type post
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //pass the post into the function
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            
            self.postImg.image = img
            
        } else {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 4 * 5000 * 5000, completion: { (data, error) in
               
                if error != nil {
                    
                    print("CAM: Unable to download image from Firebase storage")
                    
                } else {
                    
                    print("CAM: Image downloaded from Firebase storage")
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            
                            self.postImg.image = img
                            FeedViewController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
    }

}
