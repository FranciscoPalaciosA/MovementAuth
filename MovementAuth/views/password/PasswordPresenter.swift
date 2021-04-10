//
//  PasswordPresenter.swift
//  MovementAuth
//
//  Created by Fran on 03/04/21.
//

import Foundation
import Alamofire

struct AllMovements: Encodable {
    let movement_data: [Movement]
}

class PasswordPresenter: BasePresenter, PasswordPresenterDelegate {

    var mView: PasswordViewDelegate
    let baseURL = "https://movementauth.df.r.appspot.com/api/v1" // "http://192.168.1.101:8000/api/v1"
    
    init(v: PasswordViewDelegate) {
        self.mView = v
        super.init()
    }
    
    
    func sendAllMovements(allMovements: [Movement], completion: @escaping ([String]) -> Void) {
        let movData = AllMovements(movement_data: allMovements)
        AF.request(baseURL + "/data/get-sequence", method: .post,  parameters: movData, encoder: JSONParameterEncoder.default) .responseJSON { response in
            
            completion(response.value as! [String])
        }
        
        
    }
}
