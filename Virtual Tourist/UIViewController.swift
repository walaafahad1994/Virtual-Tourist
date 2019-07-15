//
//  UIViewController.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 7/15/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import Foundation
import UIKit

    extension UIViewController {
        func showNotify(title: String, message: String?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

