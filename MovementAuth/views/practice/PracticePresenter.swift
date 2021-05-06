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
    let baseURL = "https://movementauth.df.r.appspot.com/api/v1"
    
    init(v: PracticeViewDelegate) {
        self.mView = v
        super.init()
    }
    
    
    func checkMovement(userId: String, movement: String, x_arr: [Double],
                     y_arr: [Double], z_arr: [Double],
                     w_arr: [Double], completion: @escaping (Bool) -> Void) {
        
        let movData = MovementData(userId: userId,
                                   movement: movement,
                                   movement_data: [
                                    "x": x_arr,
                                    "y": y_arr,
                                    "z": z_arr,
                                    "w": w_arr,
                                   ])
    
        AF.request(baseURL + "/data/check-movement", method: .post,  parameters: movData, encoder: JSONParameterEncoder.default)
            .responseJSON { response in
                switch response.result {
                         case .success:
                            let bool = response.value as! Bool
                            completion(bool)
                         case .failure(let error):
                            completion(false)
                         }
            }
    }
}
