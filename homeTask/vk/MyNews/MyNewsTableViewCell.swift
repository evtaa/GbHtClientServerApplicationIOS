//
//  MyNewsTableViewCell.swift
//  vk
//
//  Created by Alexandr Evtodiy on 02.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import UIKit

class MyNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarShadow: UIView!
    @IBOutlet weak var avatarMyFriendNews: UIImageView!
    @IBOutlet weak var nameMyFriendNews: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var contentLabelNews: UILabel!
    @IBOutlet weak var imageContentView: UIImageView!
    @IBOutlet weak var likeUIControl: LikeUIControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarMyFriendNews.layer.cornerRadius = avatarMyFriendNews.frame.height/2
        let f = avatarMyFriendNews.frame
        avatarShadow.frame = CGRect (x: f.origin.x,
                                     y: f.origin.y,
                                     width: f.width,
                                     height: f.height)
        
        avatarShadow.layer.shadowColor = UIColor.black.cgColor
        avatarShadow.layer.shadowOpacity = 0.5
        avatarShadow.layer.shadowRadius = 10
        avatarShadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        avatarShadow.layer.cornerRadius = avatarShadow.bounds.height/2
        
        // Initialization code
    }
    
    func setup (new: VkApiNewItem) {
        avatarMyFriendNews.image = getUIImageFromURL(inputURL: new.avatarImageURL ?? "")
        nameMyFriendNews.text = new.nameGroupOrUser

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        date.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(new.date)))
        
        contentLabelNews.text = new.text
        imageContentView.image = getUIImageFromURL(inputURL: new.photoImageURL ?? "")
        
        let userLike = new.userLikes != 0
        likeUIControl.likeButton.setTitle(userLike ? "❤" : "💜", for: .normal)
        let likesCount = new.likesCount
        likeUIControl.likeLabel.text = String (likesCount)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: CustomFunction
    
    func getUIImageFromURL ( inputURL: String) -> UIImage {
        let url = URL(string: inputURL)
        if let data = try? Data(contentsOf: url!)
            {
                return UIImage(data: data) ?? UIImage()
            }
        return  UIImage()
    }
}
