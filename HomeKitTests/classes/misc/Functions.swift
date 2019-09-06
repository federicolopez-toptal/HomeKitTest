//
//  Functions.swift
//  HomeKitTests
//
//  Created by Federico Lopez on 10/07/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

func ALERT_TEXTFIELD(title: String?, msg: String?, textPlaceHolder: String, viewController: UIViewController, callback: @escaping (String?) -> () ) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
    alert.addTextField { textField in
        textField.placeholder = textPlaceHolder
    }
    
    let okAction = UIAlertAction(title: "Create", style: .default) { _ in
        if let text = alert.textFields?[0].text {
            callback(text)
        }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    viewController.present(alert, animated: true)
}
