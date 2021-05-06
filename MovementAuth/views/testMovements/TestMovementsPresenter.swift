//
//  TestMovementsPresenter.swift
//  MovementAuth
//
//  Created by Fran on 04/03/21.
//

import Foundation
import CoreMotion
import Alamofire

struct MovementData: Encodable {
    let userId: String
    let movement: String
    let movement_data: [String: [Double]]
}

class TestMovementsPresenter: BasePresenter, TestMovementsPresenterDelegate {

    var mView: TestMovementsViewDelegate
    let baseURL = "https://movementauth.df.r.appspot.com/api/v1" // "http://0.0.0.0:8000/api/v1"
    
    init(v: TestMovementsViewDelegate) {
        self.mView = v
        super.init()
    }
    
    func saveDataOnDB(movement: String, x_arr: [Double], y_arr: [Double], z_arr: [Double], w_arr: [Double]) {
        let movData = MovementData(userId: "", movement: movement,
                                   movement_data: [
                                    "x": x_arr,
                                    "y": y_arr,
                                    "z": z_arr,
                                    "w": w_arr,
                                   ])
    
        AF.request(baseURL + "/data", method: .post,  parameters: movData, encoder: JSONParameterEncoder.default)
            .responseJSON { response in
                switch response.result {
                         case .success:
                            self.mView.showMessage("Validation Successful")
                         case .failure(let error):
                            print(error)
                         }
            }
    }
}
