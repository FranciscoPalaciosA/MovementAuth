//
//  Practice.swift
//  MovementAuth
//
//  Created by Fran on 02/04/21.
//

import Foundation
import UIKit

protocol PracticeViewDelegate: BaseViewDelegate {

}

protocol PracticePresenterDelegate: BasePresenterDelegate{
    
    func checkMovement(userId: String, movement: String, x_arr: [Double],
                       y_arr: [Double], z_arr: [Double],
                       w_arr: [Double], completion: @escaping (Bool) -> Void)
}
