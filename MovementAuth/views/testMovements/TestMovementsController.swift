//
//  TestMovementsController.swift
//  MovementAuth
//
//  Created by Fran on 04/03/21.
//

import Foundation
import CoreMotion
import UIKit

class TestMovementsController: BaseController, TestMovementsViewDelegate {
    
    var mPresenter: TestMovementsPresenter?
    var motionManager = CMMotionManager()
    var queue: OperationQueue = OperationQueue()
    var isRecording = false
    
    @IBOutlet weak var vAction: UIButton!
    
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
    func startQueuedUpdates() {
        if motionManager.isDeviceMotionAvailable {
          self.motionManager.deviceMotionUpdateInterval = 60.0 / 60.0
          self.motionManager.showsDeviceMovementDisplay = true
          self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                   to: self.queue, withHandler: { (data, error) in
             // Make sure the data is valid before accessing it.
             if let validData = data {
                // Get the attitude relative to the magnetic north reference frame.
                let roll = validData.attitude.roll
                let pitch = validData.attitude.pitch
                let yaw = validData.attitude.yaw
                
                print("\n\n\n ---- New Movement  ----")
                print("  attitude =", validData.attitude)
                print("  gravity =", validData.gravity)
                print("  heading =", validData.heading)
                print("  magneticField =", validData.magneticField)
                print("  rotationRate =", validData.rotationRate)
                print("  sensorLocation =", validData.sensorLocation.rawValue)
                print("  userAcceleration =", validData.userAcceleration)
             }
          })
       }
    }
    
   
    // Auxiliar Functions
    static func getController() -> TestMovementsController{
        return CommonUtils.getController(withId: "TestMovementsController") as! TestMovementsController
    }
    
    // Click handlers
    @IBAction func onClick(_ sender: Any) {
        if(!isRecording){
            vAction.setTitle("End movement", for: .normal)
            startQueuedUpdates()
        } else {
            vAction.setTitle("Start movement", for: .normal)
            motionManager.stopDeviceMotionUpdates()
        }
        isRecording = !isRecording

    }
    
}
