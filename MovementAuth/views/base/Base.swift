//
//  Base.swift
//  MovementAuth
//
//  Created by Fran on 02/03/21.
//

import Foundation

protocol BaseViewDelegate {
    
    func showError(_ message: Error)
    
    func showMessage(_ message: String)

}

protocol BasePresenterDelegate {
    
    
}
