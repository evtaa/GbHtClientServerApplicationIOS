//
//  User.swift
//  Example
//
//  Created by Alexandr Evtodiy on 30.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import Foundation

class VkApiUsersResponse: Decodable {
    let response: VkApiUsersResponseItems
}

class VkApiUsersResponseItems: Decodable {
    let items: [VkApiUsersItem]
}

class VkApiUsersItem: Decodable {
    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var cityTitle: String = ""
    dynamic var avatarPhotoURL: String? = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case city
        case photo_200
    }
    enum CityKeys: String, CodingKey {
       // case id
        case title
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .first_name)
        self.lastName = try values.decode(String.self, forKey: .last_name)
        self.avatarPhotoURL = try values.decode(String.self, forKey: .photo_200)
        let cityValues = try values.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        self.cityTitle = try cityValues.decode(String.self, forKey: .title)
        
        debugPrint("id = \(self.id),name = \(self.firstName) \(lastName),avatarPhotoURL = \(String(describing: self.avatarPhotoURL)), cityTitle = \(self.cityTitle)")
        
        
    }
}
