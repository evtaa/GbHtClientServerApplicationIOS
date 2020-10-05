//
//  MyCommunitiesTableViewController.swift
//  vk
//
//  Created by Alexandr Evtodiy on 07.08.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import UIKit

class MyCommunitiesTableViewController: UITableViewController {
    
    var myGroups: [VkApiGroupItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vkService = VKService ()
        // отправим запрос для получения  групп пользователя
        vkService.loadGroupsData(userId: String(Session.instance.userId!)) { [weak self] myGroups in
            // сохраняем полученные данные в массиве
            self?.myGroups = myGroups
            self?.tableView.reloadData()
        }
        
        // Убираем разделительные линии между пустыми ячейками
        tableView.tableFooterView = UIView ()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let count  = self.myGroups?.count else {
                    return 0
                }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommunitiesCell", for: indexPath) as! MyCommunitiesTableViewCell
        
        guard let myGroup  = self.myGroups?[indexPath.row] else {
                    return cell
                }
        cell.setup(group: myGroup)
        
        return cell
    }
    
    // Override to support editing the table view.
    
//    // Здесь нужно вызвать запрос серверу на удаление из группы
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            myCommunities.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
    // MARK: -Segue
    //Здесь нужно вызвать запрос серверу на добавление группы
//    @IBAction func addCommunity (segue: UIStoryboardSegue) {
//        if segue.identifier == "addCommunity" {
//            let allCommunitiesTableViewController = segue.source as! AllCommunitiesTableViewController
//            if let indexPath = allCommunitiesTableViewController.tableView.indexPathForSelectedRow {
//                let community = allCommunitiesTableViewController.allCommunities [indexPath.row]
//                if !myCommunities.contains(where: {myCommunity -> Bool in
//                    return community == myCommunity
//                }) {
//                    myCommunities.append(community)
//                    tableView.reloadData()
//                }
//            }
//        }
//    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
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
