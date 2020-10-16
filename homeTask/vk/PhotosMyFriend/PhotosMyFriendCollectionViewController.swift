//
//  PhotoMyFriendCollectionViewController.swift
//  vk
//
//  Created by Alexandr Evtodiy on 07.08.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import UIKit

class PhotosMyFriendCollectionViewController: UICollectionViewController {
    
    internal let newRefreshControl = UIRefreshControl()
    
    var friendSelected : VkApiUsersItem?
    var photosFriend = [VkApiPhotoItem] ()
    let vkService = VKService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView ()
        setupRefreshControl ()
        // отправим запрос для получения  фотографий пользователя
        fetchPhotosData ()
    }
    
    private func setupCollectionView () {
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = newRefreshControl
        } else {
            collectionView.addSubview(newRefreshControl)
        }
        
        // Выставляем заголовок в навигации
        if let lastName = friendSelected?.lastName,
           let firstName = friendSelected?.firstName {
            self.navigationItem.title = lastName + " " + firstName
        }
    }
    
    private func setupRefreshControl () {
        // Configure Refresh Control
        newRefreshControl.addTarget(self, action: #selector(refreshPhotosData(_:)), for: .valueChanged)
        newRefreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 0.7)
    }
    
    
    @objc func refreshPhotosData(_ sender: Any) {
        
        fetchPhotosData ()
    }
    
    private func fetchPhotosData () {
        
        vkService.loadPhotosData(userId: friendSelected!.id) { [weak self] photos in
         // сохраняем полученные данные в массиве
         self?.photosFriend = photos
        self?.collectionView.reloadData()
        self?.newRefreshControl.endRefreshing()
     }
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.photosFriend.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Получаем ячейку из пула
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSelectedFriend", for: indexPath) as! PhotosMyFriendCollectionViewCell
        
        let photoFriend  = self.photosFriend [indexPath.row]
        cell.setup(photoFriend: photoFriend)

        return cell
        
        // Configure the cell
        
    }
    
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            // Проверяем идентификатор чтобы убедиться, что это нужный переход
                if segue.identifier == "getSelectedFriendAndCurrentPhoto" {
                    // Создаем указатель контроллера на который будет осуществлен переход
                    let photosMyFriendsSwipeViewController = segue.destination as? PhotosMyFriendsSwipeViewController
                    // Получаем индекс выделенной ячейки таблицы
                    if let indexPaths = self.collectionView.indexPathsForSelectedItems {
                        // Передаем экземпляр объекта класса User контроллеру на который будет осуществлен переход
                        
                        photosMyFriendsSwipeViewController?.photosFriend = photosFriend
                        photosMyFriendsSwipeViewController?.friendSelected = friendSelected
                        photosMyFriendsSwipeViewController?.indexImage = indexPaths[0].row
                    }
                }
        }
        
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
