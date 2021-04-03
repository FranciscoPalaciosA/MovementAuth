//
//  PasswordPresenter.swift
//  MovementAuth
//
//  Created by Fran on 03/04/21.
//

import Foundation
import Alamofire

class PasswordPresenter: BasePresenter, PasswordPresenterDelegate {

    var mView: PasswordViewDelegate
    let baseURL = "https://movementauth-backend-npohk6ommq-uc.a.run.app/api/v1"
    
    init(v: PasswordViewDelegate) {
        self.mView = v
        super.init()
    }
    
    
    func sendAllMovements(allMovements: [Movement], completion: @escaping ([String]) -> Void) {
        
        print(allMovements)
    
        /*AF.request(baseURL + "/data/get-shapes", method: .post,  parameters: allMovements, encoder: JSONParameterEncoder.default)
            .responseJSON { response in
                print(response)
                completion(true)
            }*/
        completion(["1", "3", "A", "D"])
    }
}
