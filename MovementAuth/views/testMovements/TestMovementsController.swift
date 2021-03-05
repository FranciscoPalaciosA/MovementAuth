//
//  TestMovementsController.swift
//  MovementAuth
//
//  Created by Fran on 04/03/21.
//

import Foundation
import CoreMotion

class TestMovementsController: BaseController, TestMovementsViewDelegate {
    
    var mPresenter: TestMovementsPresenter?
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = TestMovementsPresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
     
    }

    func initController() {
        print("If its available = ", motionManager.isDeviceMotionAvailable)
    }
    
    // Primary Functions
    
   
        
    // Auxiliary functions
    // Auxiliar Functions
    static func getController() -> TestMovementsController{
        return CommonUtils.getController(withId: "TestMovementsController") as! TestMovementsController
    }
}
