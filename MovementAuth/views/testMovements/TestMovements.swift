//
//  TestMovement.swift
//  MovementAuth
//
//  Created by Fran on 04/03/21.
//

import Foundation
import CoreMotion
import UIKit

protocol TestMovementsViewDelegate: BaseViewDelegate {

}

protocol TestMovementsPresenterDelegate: BasePresenterDelegate{
    
    func saveDataOnDB(movement: String, x_arr: [Double], y_arr: [Double], z_arr: [Double], w_arr: [Double])
    
}
