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
        let movData = MovementData(movement: movement,
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
    
    
    /*
     // prepare json data
     let json: [String: Any] = ["title": "ABC",
                                "dict": ["1":"First", "2":"Second"]]

     let jsonData = try? JSONSerialization.data(withJSONObject: json)
     
     
     // Prepare URL
     let url = URL(string: "https://jsonplaceholder.typicode.com/todos")
     guard let requestUrl = url else { fatalError() }
     // Prepare URL Request Object
     var request = URLRequest(url: requestUrl)
     request.httpMethod = "POST"
      
     // insert json data to the request
     request.httpBody = jsonData
     // Perform HTTP Request
     let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             
             // Check for Error
             if let error = error {
                 print("Error took place \(error)")
                 return
             }
      
             // Convert HTTP Response Data to a String
             if let data = data, let dataString = String(data: data, encoding: .utf8) {
                 print("Response data string:\n \(dataString)")
             }
     }
     task.resume()
     */
}
