//
//  Password.swift
//  MovementAuth
//
//  Created by Fran on 03/04/21.
//

import Foundation
import UIKit

protocol PasswordViewDelegate: BaseViewDelegate {

}

protocol PasswordPresenterDelegate: BasePresenterDelegate{
    func sendAllMovements(allMovements: [Movement], completion: @escaping ([String]) -> Void)
}
