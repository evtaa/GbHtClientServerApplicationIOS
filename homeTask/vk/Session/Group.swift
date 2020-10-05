//
//  GroupClass.swift
//  Example
//
//  Created by Alexandr Evtodiy on 01.10.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import Foundation

class VkApiGroupResponse: Decodable {
    let response: VkApiGroupResponseItems
}

class VkApiGroupResponseItems: Decodable {
    let items: [VkApiGroupItem]
}

class VkApiGroupItem: Decodable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var screenName: String = ""
    dynamic var photoSmallURL: String = ""
    dynamic var photoMediumURL: String = ""
    dynamic var photoLargeURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screen_name
        case photo_50
        case photo_100
        case photo_200
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.screenName = try values.decode(String.self, forKey: .screen_name)
        self.photoSmallURL = try values.decode(String.self, forKey: .photo_50)
        self.photoMediumURL = try values.decode(String.self, forKey: .photo_100)
        self.photoLargeURL = try values.decode(String.self, forKey: .photo_200)
        
        
        debugPrint("id = \(self.id),name = \(self.name),screenName = \(String(describing: self.screenName)), photoSmallURL = \(self.photoSmallURL), photoMediumURL = \(self.photoMediumURL), photoLargeURL = \(self.photoLargeURL)")
        
        
    }
}
