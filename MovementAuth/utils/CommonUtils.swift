//
//  CommonUtils.swift
//  MovementAuth
//
//  Created by Fran on 02/03/21.
//

import Foundation
import UIKit

class CommonUtils {
    
    class func getController(withId id: String) -> UIViewController {
        return getStoryboard(withName: id).instantiateViewController(withIdentifier: id)
    }
    
    class func getStoryboard(withName name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
    class func setCorners(forViews views: [UIView]) {
        for v in views {
            v.layer.cornerRadius = 12
        }
    }
    
    class func setShadow(forViews views: [UIView]) {
        for v in views {
            v.clipsToBounds = false
            v.layer.shadowOpacity = 0.3
            v.layer.shadowOffset = CGSize(width: 0, height: 1)
            v.layer.shadowRadius = 3.0
            v.layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
    
}
