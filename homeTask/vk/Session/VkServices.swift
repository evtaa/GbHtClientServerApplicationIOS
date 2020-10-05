//
//  VKServices.swift
//  Example
//
//  Created by Alexandr Evtodiy on 27.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class VKService {
    // базовый URL сервиса
    let baseUrl = "https://api.vk.com/method"
    
    // Функция получения списка друзей пользователя
    func loadFriendsData(userId: String, completion: @escaping ([VkApiUsersItem]) -> Void){
        
        let path = "/friends.get"
        let parameters: Parameters = [
            "user_id": userId,
            "order": "name",
            //"list_id": "",
            //"count": "10",
            "offset": "0",
            "fields": "city,photo_200",
            "name_case": "nom",
            "v": "5.68",
            "access_token": Session.instance.token!
        ]
        
        // составляем URL из базового адреса сервиса и конкретного метода
        let url = baseUrl+path
        // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiUsersResponse = try JSONDecoder().decode (VkApiUsersResponse.self, from: data)
                    completion (vkApiUsersResponse.response.items)
                debugPrint (data)
                }
                catch DecodingError.dataCorrupted(let context) {
                    debugPrint(DecodingError.dataCorrupted(context))
                }
                catch let error {
                                    debugPrint("Decoding's error \(url)")
                                    debugPrint(error)
                                    debugPrint(String(bytes: data, encoding: .utf8) ?? "")
                                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // Функция получения фотографий пользователя
    func loadPhotosData (userId: Int, completion: @escaping ([VkApiPhotoItem]) -> Void) {
        
        let path = "/photos.get"
        let parameters: Parameters = [
            "owner_id": String(userId),
            "album_id": "wall",
            //"photo_ids": "",
            //"rev": "0",
            "extended": "1",
            //"feed_type": "",
            //"feed": "",
            "photo_sizes": "1",
            "offset": "0",
            //"count": "",
            "v": "5.68",
            "access_token": Session.instance.token!
        ]
        
        // составляем URL из базового адреса сервиса и конкретного метода
        let url = baseUrl+path
        // делаем запрос
      
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiPhotoResponse = try JSONDecoder().decode (VkApiPhotoResponse.self, from: data)
                    completion (vkApiPhotoResponse.response.items)
                debugPrint (data)
                }
                catch DecodingError.dataCorrupted(let context) {
                    debugPrint(DecodingError.dataCorrupted(context))
                }
                catch let error {
                                    debugPrint("Decoding's error \(url)")
                                    debugPrint(error)
                                    debugPrint(String(bytes: data, encoding: .utf8) ?? "")
                                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // Функция получения списка групп  пользователя
    func loadGroupsData (userId: String, completion: @escaping ([VkApiGroupItem]) -> Void) {
           
           let path = "/groups.get"
           let parameters: Parameters = [
               "user_id": userId,
               "extended": "1",
               //"filter": "0",
               //"fields": "0",
               //"offset": "0",
               //"count": "50",
               "v": "5.68",
               "access_token": Session.instance.token!
           ]
           
           // составляем URL из базового адреса сервиса и конкретного метода
           let url = baseUrl+path
           // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiGroupResponse = try JSONDecoder().decode (VkApiGroupResponse.self, from: data)
                    completion (vkApiGroupResponse.response.items)
                debugPrint (data)
                }
                catch DecodingError.dataCorrupted(let context) {
                    debugPrint(DecodingError.dataCorrupted(context))
                }
                catch let error {
                                    debugPrint("Decoding's error \(url)")
                                    debugPrint(error)
                                    debugPrint(String(bytes: data, encoding: .utf8) ?? "")
                                }
            case .failure(let error):
                debugPrint(error)
            }
        }
       }
    
    // Получения списка групп по заданной подстроке
    func loadSearchGroupsData (search: String, completion: @escaping ([VkApiGroupItem]) -> Void) {
        
        let path = "/groups.search"
        let parameters: Parameters = [
            "q": search,
            //"type": "group",
            //"country_id": "0",
            //"city_id": "0",
            //"future": "0",
            //"market": "0",
            //"sort": "0",
            //"offset": "3",
            "count": "5",
            "v": "5.68",
            "access_token": Session.instance.token!
        ]
        
        // составляем URL из базового адреса сервиса и конкретного метода
        let url = baseUrl+path
        // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiSearchGroupResponse = try JSONDecoder().decode (VkApiGroupResponse.self, from: data)
                completion (vkApiSearchGroupResponse.response.items)
                debugPrint (data)
                }
                catch DecodingError.dataCorrupted(let context) {
                    debugPrint(DecodingError.dataCorrupted(context))
                }
                catch let error {
                                    debugPrint("Decoding's error \(url)")
                                    debugPrint(error)
                                    debugPrint(String(bytes: data, encoding: .utf8) ?? "")
                                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}


