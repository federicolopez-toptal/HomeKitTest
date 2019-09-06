//
//  HomeKitManager.swift
//  HomeKitTests
//
//  Created by Federico Lopez on 10/07/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//


import HomeKit

protocol HomeKitManagerDelegate: AnyObject {
    func HomeKitManager_HomesUpdated(sender: HomeKitManager)
}


class HomeKitManager: NSObject {
    weak var delegate: HomeKitManagerDelegate?
    
    var homes: [HMHome] = []
    let homeManager = HMHomeManager()
    
    override init() {
        super.init()
        homeManager.delegate = self
        addHomes(homeManager.homes)
    }
    
    func addHomes(_ homes: [HMHome]) {
        self.homes.removeAll()
        for home in homes {
            self.homes.append(home)
        }
        delegate?.HomeKitManager_HomesUpdated(sender: self)
    }
    
    func addHome(name: String) {
        homeManager.addHome(withName: name) { (home, error) in
            if(error != nil) {
                print("Error: \(error?.localizedDescription)")
            } else {
                // Home added successfully
                print("yeah!")
            }
        }
    }
    
}

// HMHomeManagerDelegate
extension HomeKitManager: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        addHomes(manager.homes)
    }

}
