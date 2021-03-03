//
//  BaseController.swift
//  MovementAuth
//
//  Created by Fran on 02/03/21.
//

import Foundation
import UIKit

class BaseController: UIViewController, BaseViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showError(_ error: Error) {
        let e = error as NSError
        NSLog("\(e.code): \(e.localizedDescription)")
        showMessage(e.localizedDescription)
    }
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(
            title: "",
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let action = UIAlertAction(
            title: "Ok",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
