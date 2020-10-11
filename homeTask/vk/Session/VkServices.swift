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
    let storeStack = CoreDataStack(modelName: "VKDataBase")
    
    // MARK: Functions for users

    // Function for a save user
    func saveUser (user: VkApiUsersItem) {
        
        let context = storeStack.context
        let userDB = UserDB(context: context)
        userDB.id = Int32(user.id)
        userDB.firstName = user.firstName
        userDB.lastName = user.lastName
        userDB.cityTitle = user.cityTitle
        userDB.avatarPhotoURL = user.avatarPhotoURL
    }
    // Function for save user's list
    func saveUsers(users: [VkApiUsersItem]) {
        
        for user in users {
            self.saveUser(user: user)
        }
    }
    // Function for load a user's list
    func readUserList () -> [UserDB] {
        let context = storeStack.context
        return (try? context.fetch(UserDB.fetchRequest()) as? [UserDB]) ?? []
    }
    func getListFriendsFromListFriendsBD (listFriendsBD: [UserDB]) -> [VkApiUsersItem] {
        
        var userList:[VkApiUsersItem] = [VkApiUsersItem] ()
        for index in 0...listFriendsBD.count-1 {
            userList.append(VkApiUsersItem ())
            userList[index].id = Int(listFriendsBD[index].id)
            userList[index].firstName = listFriendsBD[index].firstName ?? ""
            userList[index].lastName = listFriendsBD[index].lastName ?? ""
            userList[index].cityTitle =  listFriendsBD[index].cityTitle ?? ""
            userList[index].avatarPhotoURL =  listFriendsBD[index].avatarPhotoURL
        }
        return userList.sorted { $0.id < $1.id }
    }
    
    // MARK: Functions for photos

    // Function for a save photo
    func savePhoto (photo: VkApiPhotoItem) {
        
        let context = storeStack.context
        let photoDB = PhotoDB(context: context)
        photoDB.id = Int32(photo.id)
        photoDB.date = Int32(photo.date)
        photoDB.ownerId = Int32(photo.ownerId)
        photoDB.likesCount = Int32(photo.likesCount)
        photoDB.userLike = Int32(photo.userLike)
        photoDB.photoSmallURL = photo.photoSmallURL
        photoDB.photoMediumURL = photo.photoMediumURL
        photoDB.photoLargeURL = photo.photoLargeURL
    }
    // Function for save photo's list
    func savePhotos(photos: [VkApiPhotoItem]) {
        
        for photo in photos {
            self.savePhoto(photo: photo)
        }
    }
    // Function for load a user's list
    func readPhotoList () -> [PhotoDB] {
        let context = storeStack.context
        return (try? context.fetch(PhotoDB.fetchRequest()) as? [PhotoDB]) ?? []
    }
    func getListPhotosFromListPhotosBD (listPhotosBD: [PhotoDB]) -> [VkApiPhotoItem] {
        
        var photoList:[VkApiPhotoItem] = [VkApiPhotoItem] ()
        for index in 0...listPhotosBD.count-1 {
            photoList.append(VkApiPhotoItem ())
            photoList[index].id = Int(listPhotosBD[index].id)
            photoList[index].date = Int(listPhotosBD[index].date)
            photoList[index].ownerId = Int(listPhotosBD[index].ownerId)
            photoList[index].likesCount =  Int(listPhotosBD[index].likesCount)
            photoList[index].userLike =  Int(listPhotosBD[index].userLike)
            photoList[index].photoSmallURL =  listPhotosBD[index].photoSmallURL ?? ""
            photoList[index].photoMediumURL =  listPhotosBD[index].photoMediumURL ?? ""
            photoList[index].photoLargeURL =  listPhotosBD[index].photoLargeURL ?? ""
        }
        return photoList.sorted { $0.id < $1.id }
    }
    
    // MARK: Functions for groups

    // Function for a save user
    func saveGroup (group: VkApiGroupItem) {
        
        let context = storeStack.context
        let groupDB = GroupDB (context: context)
        groupDB.id = Int32(group.id)
        groupDB.name = group.name
        groupDB.screenName = group.screenName
        groupDB.photoSmallURL = group.photoSmallURL
        groupDB.photoMediumURL = group.photoMediumURL
        groupDB.photoLargeURL = group.photoLargeURL
    }
    // Function for save user's list
    func saveGroups(groups: [VkApiGroupItem]) {
        
        for group in groups {
            self.saveGroup(group: group)
        }
    }
    // Function for load a user's list
    func readGroupList () -> [GroupDB] {
        let context = storeStack.context
        return (try? context.fetch(GroupDB.fetchRequest()) as? [GroupDB]) ?? []
    }
    func getListGroupsFromListGroupsBD (listGroupsBD: [GroupDB]) -> [VkApiGroupItem] {
        
        var groupList:[VkApiGroupItem] = [VkApiGroupItem] ()
        for index in 0...listGroupsBD.count-1 {
            groupList.append(VkApiGroupItem ())
            groupList[index].id = Int(listGroupsBD[index].id)
            groupList[index].name = listGroupsBD[index].name ?? ""
            groupList[index].screenName = listGroupsBD[index].screenName ?? ""
            groupList[index].photoSmallURL =  listGroupsBD[index].photoSmallURL ?? ""
            groupList[index].photoMediumURL =  listGroupsBD[index].photoMediumURL ?? ""
            groupList[index].photoLargeURL =  listGroupsBD[index].photoLargeURL ?? ""
        }
        return groupList.sorted { $0.id < $1.id }
    }
    
  
    
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
        Alamofire.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiUsersResponse = try JSONDecoder().decode (VkApiUsersResponse.self, from: data)
                    let VkApiUsersResponseItems = vkApiUsersResponse.response.items
                    
                    // Save user array to Database
                   
                    self?.saveUsers(users: VkApiUsersResponseItems)
                    let userListDB = self!.readUserList()
                    
                    for user in userListDB {
                        debugPrint("Чтение users из VKDataBase:")
                        debugPrint( user.id,user.firstName, user.lastName, user.cityTitle, user.avatarPhotoURL)
                    }
                    let userList = self?.getListFriendsFromListFriendsBD(listFriendsBD: userListDB)
                    completion (userList ?? [VkApiUsersItem] ())
                    
                    
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
      
        Alamofire.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiPhotoResponse = try JSONDecoder().decode (VkApiPhotoResponse.self, from: data)
                    let VkApiPhotosResponseItems = vkApiPhotoResponse.response.items
                    // Save user array to Database
                    
                    self?.savePhotos(photos: VkApiPhotosResponseItems)
                    let photoListDB = self!.readPhotoList()
                    
                    for photo in photoListDB {
                        debugPrint("Чтение photos из VKDataBase:")
                        debugPrint( photo.id,photo.date, photo.ownerId, photo.likesCount, photo.userLike, photo.photoSmallURL, photo.photoMediumURL, photo.photoLargeURL)
                    }
                    let photoList = self?.getListPhotosFromListPhotosBD(listPhotosBD: photoListDB)
                    completion (photoList ?? [VkApiPhotoItem] ())
                    
                    
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
        Alamofire.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            switch response.result{
            case .success(let data):
                do {
                    let  vkApiGroupResponse = try JSONDecoder().decode (VkApiGroupResponse.self, from: data)
                    let VkApiGroupsResponseItems = vkApiGroupResponse.response.items
                    
                    // Save group array to Database
                   
                    self?.saveGroups(groups: VkApiGroupsResponseItems)
                    let groupListDB = self!.readGroupList()
                    
                    for group in groupListDB {
                        debugPrint("Чтение groups из VKDataBase:")
                        debugPrint( group.id,group.name, group.screenName, group.photoSmallURL, group.photoMediumURL, group.photoLargeURL)
                    }
                    let groupList = self?.getListGroupsFromListGroupsBD(listGroupsBD: groupListDB)
                    completion (groupList ?? [VkApiGroupItem] ())
                    
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


