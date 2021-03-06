//
//  MyFriendsTableViewCell.swift
//  vk
//
//  Created by Alexandr Evtodiy on 06.08.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: AvatarCompositeView!
    @IBOutlet weak var userName: UILabel!
    
    // MARK: Animation
    
    @IBAction func downButtonTouchDown(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.avatarView.avatarShadow.bounds.size.height -= 10
                        self.avatarView.avatarShadow.bounds.size.width -= 10
                        self.avatarView.avatarShadow.layer.cornerRadius -=  5
                        
                        self.avatarView.avatarPhoto.bounds.size.height -= 10
                        self.avatarView.avatarPhoto.bounds.size.width -= 10
                        self.avatarView.avatarPhoto.layer.cornerRadius -=  5
        })
        
    }
    
    @IBAction func upButtonTouchUpInside(_ sender: Any) {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 2,
                       options: [],
                       animations: {
                        self.avatarView.avatarShadow.bounds.size.height += 10
                        self.avatarView.avatarShadow.bounds.size.width += 10
                        self.avatarView.avatarShadow.layer.cornerRadius +=  5
                        
                        self.avatarView.avatarPhoto.bounds.size.height += 10
                        self.avatarView.avatarPhoto.bounds.size.width += 10
                        self.avatarView.avatarPhoto.layer.cornerRadius +=  5
        })
    }
    
    @IBAction func upButtonTouchUpOutside(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 2,
                       options: [],
                       animations: {
                        self.avatarView.avatarShadow.bounds.size.height += 10
                        self.avatarView.avatarShadow.bounds.size.width += 10
                        self.avatarView.avatarShadow.layer.cornerRadius +=  5
                        
                        self.avatarView.avatarPhoto.bounds.size.height += 10
                        self.avatarView.avatarPhoto.bounds.size.width += 10
                        self.avatarView.avatarPhoto.layer.cornerRadius +=  5
        })
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    // MARK: Configure Cell
    
    func setup (user: VkApiUsersItem) {
        
        avatarView.avatarPhoto.image  =  self.getUIImageFromURL(inputURL: user.avatarPhotoURL!)
        userName.text = user.lastName + " " + user.firstName
        avatarView.setup()
    }
}
