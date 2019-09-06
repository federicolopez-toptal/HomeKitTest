//
//  HomesViewController.swift
//  HomeKitTests
//
//  Created by Federico Lopez on 10/07/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit


class HomesViewController: UIViewController, HomeKitManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var homeManager: HomeKitManager!   // my class to manage all HomeKit related stuff
    @IBOutlet weak var homesList: UITableView!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        setupComponents()
        
        homeManager = HomeKitManager()
        homeManager.delegate = self
    }
    
    func customizeView() {
        title = "Homes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newHome(sender:)))
    }
    
    func setupComponents() {
        homesList.tableFooterView = UIView()
        homesList.delegate = self
        homesList.dataSource = self
        
        let nib = UINib.init(nibName: "HomeCell", bundle: nil)
        homesList.register(nib, forCellReuseIdentifier: "HomeCell")
    }
    
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeManager.homes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let H = homeManager.homes[indexPath.row]
        cell.NameLabel.text = H.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            let H = self.homeManager.homes[indexPath.row]
            self.homeManager.removeHome(home: H, callback: { (error) in
                if(error == nil) {
                    self.homesList.reloadData()
                }
            })
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserSelection.shared.home = self.homeManager.homes[indexPath.row]
        self.performSegue(withIdentifier: "gotoRooms", sender: self)
    }
    
    
    // MARK: - Some actions
    @objc func newHome(sender: UIBarButtonItem) {
        ALERT_TEXTFIELD(title: "Create new home", msg: nil, textPlaceHolder: "Enter home name", viewController: self){ (text) in
            if let T = text {
                self.homeManager.addHome(name: T, callback: { (error) in
                    self.homesList.reloadData()
                })
            }
                    
        }
    }
    
    
    // MARK: - HomeKitManagerDelegate
    func HomeKitManager_didUpdateHomes(sender: HomeKitManager) {
        homesList.reloadData()
    }
    
}




/*
func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
     }
     editAction.backgroundColor = UIColor.green
    
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
        let H = self.homeManager.homes[indexPath.row]
        self.homeManager.removeHome(home: H, callback: { (error) in
            if(error == nil) {
                self.homesList.reloadData()
            }
        })
    }
    
    return [deleteAction, editAction]
}
*/
