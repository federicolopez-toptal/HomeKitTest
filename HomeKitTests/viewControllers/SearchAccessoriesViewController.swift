//
//  AccessoriesViewController.swift
//  HomeKitTests
//
//  Created by Federico Lopez on 15/07/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit
import HomeKit

class SearchAccessoriesViewController: UIViewController, HomeKitManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var accesoriesLists: UITableView!
    @IBOutlet weak var loadingView: UIView!
    var accesories = [HMAccessory]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
        setupComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        HomeKitManager.shared.delegate = self
        accesories.removeAll()
        loadingView.isHidden = false
        accesoriesLists.isUserInteractionEnabled = false
        HomeKitManager.shared.searchForAccesories()
    }
    
    func customizeView() {
        title = ""
        loadingView.layer.cornerRadius = 8.0
    }
    
    func setupComponents() {
        accesoriesLists.tableFooterView = UIView()
        accesoriesLists.delegate = self
        accesoriesLists.dataSource = self
        
        let nib = UINib.init(nibName: "AccesoryCell", bundle: nil)
        accesoriesLists.register(nib, forCellReuseIdentifier: "AccesoryCell")
    }
    
    // MARK: - HomeKitManagerDelegate
    func HomeKitManager_didFoundAccesory(sender: HomeKitManager, accesory: HMAccessory) {
        accesories.append(accesory)
        accesoriesLists.reloadData()
    }
    
    func HomeKitManager_searchFinished(sender: HomeKitManager) {
        loadingView.isHidden = true
        title = "Accesories found"
        accesoriesLists.isUserInteractionEnabled = true
        
        if(accesories.isEmpty) {
            ALERT(title: "", msg: "No accesories were found", viewController: self)
        }
    }
    
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accesories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccesoryCell", for: indexPath) as! AccesoryCell
        
        let A = accesories[indexPath.row]
        cell.nameLabel.text = A.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

}
