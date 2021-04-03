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
    let baseURL = "https://movementauth-backend-npohk6ommq-uc.a.run.app/api/v1"
    
    init(v: PracticeViewDelegate) {
        self.mView = v
        super.init()
    }
    
    
    func checkMovement(movement: String, x_arr: [Double],
                     y_arr: [Double], z_arr: [Double],
                     w_arr: [Double], completion: @escaping (Bool) -> Void) {
        
        let movData = MovementData(movement: movement,
                                   movement_data: [
                                    "x": x_arr,
                                    "y": y_arr,
                                    "z": z_arr,
                                    "w": w_arr,
                                   ])
    
        AF.request(baseURL + "/data/check-movement", method: .post,  parameters: movData, encoder: JSONParameterEncoder.default)
            .responseJSON { response in
                print(response)
                completion(true)
            }
    }
}
