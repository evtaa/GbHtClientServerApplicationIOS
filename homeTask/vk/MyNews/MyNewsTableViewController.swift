//
//  MyNewsTableViewController.swift
//  vk
//
//  Created by Alexandr Evtodiy on 02.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import UIKit
import RealmSwift

class MyNewsTableViewController: UITableViewController {

    internal let newRefreshControl = UIRefreshControl()
    var myNews: [VkApiNewItem]?
    let vkService = VKService ()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView ()
        setupRefreshControl ()
        //отправим запрос для получения  новостей пользователя
        fetchNewsData ()
        pairTableAndRealm { [weak self] myNews in
            guard let tableView = self?.tableView else { return }
            self?.myNews = myNews
            tableView.reloadData()
            self?.newRefreshControl.endRefreshing()
        }
    }
    
    private func setupTableView () {
        
        self.tableView.register(UINib (nibName: "MyNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyNewsCell")

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = newRefreshControl
        } else {
            tableView.addSubview(newRefreshControl)
        }
        
        // Убираем разделительные линии между пустыми ячейками
        tableView.tableFooterView = UIView ()
    }
    
    private func setupRefreshControl () {
        // Configure Refresh Control
        newRefreshControl.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
        newRefreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 0.7)
    }
    
    @objc func refreshNewsData(_ sender: Any) {
        fetchNewsData ()
    }
    
    private func fetchNewsData () {
        vkService.loadNewsData()
    }

    func pairTableAndRealm(completion: @escaping  ([VkApiNewItem]) -> Void ) {
            guard let realm = try? Realm() else { return }
        let objects = realm.objects(VkApiNewItem.self)
        token = objects.observe { (changes: RealmCollectionChange) in
               // guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial (let results):
                    guard !results.isInvalidated else {return}
                    //let myNews = [VkApiNewItem](results)
                    let myNews = self.transRealmAnswerToArray(answer: results)
                    debugPrint(".initial : \(myNews.count) myNews loaded from DB")
                    completion(myNews)
                case .update (let results, _, _, _):
                    guard !results.isInvalidated else {return}
                    //let myNews = [VkApiNewItem](results)
                    let myNews = self.transRealmAnswerToArray(answer: results)
                    debugPrint(".update : \(myNews.count) myNews loaded from DB")
                    completion(myNews)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }
    
    private func transRealmAnswerToArray (answer: Results<VkApiNewItem>) -> [VkApiNewItem]  {
        var array:[VkApiNewItem] = [VkApiNewItem] ()
        for object in answer {
            let new: VkApiNewItem = VkApiNewItem ()
            new.avatarImageURL = object.avatarImageURL
            new.nameGroupOrUser = object.nameGroupOrUser
            new.type = object.type
            new.sourceId = Int(object.sourceId)
            new.date = Int(object.date)
            new.text =  object.text
            new.commentsCount =  Int(object.commentsCount)
            new.likesCount =  Int(object.likesCount)
            new.userLikes = Int(object.userLikes)
            new.repostCount = Int(object.repostCount)
            new.userReposted = Int(object.userReposted)
            new.typeAttachment =  object.typeAttachment
            new.photoImageURL =  object.photoImageURL
            array.append(new)
        }
        return array
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let count  = self.myNews?.count else {
                    return 0
                }
        return count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNewsCell", for: indexPath) as! MyNewsTableViewCell
        
        let numberOfRows = self.tableView.numberOfRows(inSection: 0)
        guard indexPath.row <= numberOfRows else {return cell}
        guard let myNew  = self.myNews? [indexPath.row] else {return cell}
        cell.setup(new: myNew)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
 

