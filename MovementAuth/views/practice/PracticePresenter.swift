//
//  PracticePresenter.swift
//  MovementAuth
//
//  Created by Fran on 02/04/21.
//

import Foundation
import Alamofire

class PracticePresenter: BasePresenter, PracticePresenterDelegate {

    var mView: PracticeViewDelegate
    let baseURL = "https://movementauth-backend-npohk6ommq-uc.a.run.app/api/v1" // "http://0.0.0.0:8000/api/v1"
    
    init(v: PracticeViewDelegate) {
        self.mView = v
        super.init()
    }
    
    
    func checkMovement(movement: String, x_arr: [Double],
                     y_arr: [Double], z_arr: [Double],
                     w_arr: [Double], completion: @escaping (Bool) -> Void) {

        AF.request("https://reqres.in/api/user?delay=2")
            .responseString { response in
                completion(false)
        }
    }
}
