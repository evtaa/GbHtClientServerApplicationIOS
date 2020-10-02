//
//  VkServices.swift
//  vk
//
//  Created by Alexandr Evtodiy on 27.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import Foundation

import Alamofire

class VKService {
    // базовый URL сервиса
    let baseUrl = "https://api.vk.com/method"
    
    // Функция получения списка друзей пользователя
    func getFriends(userId: Int){
        
        let path = "/friends.get"
        let parameters: Parameters = [
            "user_id": String(userId),
            "order": "name",
            //"list_id": "",
            //"count": "",
            "offset": "0",
            "fields": "nickname",
            "name_case": "ins",
            "v": "5.68",
            "access_token": Session.instance.token!
        ]
        
        // составляем URL из базового адреса сервиса и конкретного метода
        let url = baseUrl+path
        // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            debugPrint(response.value)
        }
    }
    
    // Функция получения фотографий пользователя
    func getPhotographes (userId: Int) {
        
        let path = "/photos.getAll"
        let parameters: Parameters = [
            "owner_id": String(userId),
            "extended": "1",
            //"offset": "0",
            //"count": "3",
            "photo_sizes": "0",
            "no_service_albums": "0",
            "need_hidden": "0",
            "skip_hidden": "1",
            "v": "5.68",
            "access_token": Session.instance.token!
        ]
        
        // составляем URL из базового адреса сервиса и конкретного метода
        let url = baseUrl+path
        // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            debugPrint(response.value)
        }
        
    }
    
    // Функция получения списка групп  пользователя
    func getGroups (userId: Int) {
           
           let path = "/groups.get"
           let parameters: Parameters = [
               "user_id": String(userId),
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
           Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
               debugPrint(response.value)
           }
           
       }
    
    // Функция получения списка групп по заданной подстроке
    func getGroupsSearch (search: String) {
        
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
            "count": "10",
            "v": "5.68",
            "access_token": Session.instance.token!
        ]
        
        // составляем URL из базового адреса сервиса и конкретного метода
        let url = baseUrl+path
        // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            debugPrint(response.value)
        }
    }
}
