//
//  PracticeController.swift
//  MovementAuth
//
//  Created by Fran on 02/04/21.
//

import Foundation
import UIKit
import CoreMotion

class PracticeController: BaseController, PracticeViewDelegate {
    
    var mPresenter: PracticePresenter?
    var motionManager = CMMotionManager()
    var queue: OperationQueue = OperationQueue()
    var isRecording = false
    
    @IBOutlet weak var VAction: UIButton!
    @IBOutlet weak var VExample: UIButton!
    @IBOutlet weak var LMovementTitle: UILabel!
    @IBOutlet weak var imgMovement: UIImageView!
    @IBOutlet weak var LResult: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var x_arr: [Double] = [], y_arr: [Double] = [], z_arr: [Double] = [], w_arr: [Double] = []
    var movementOptions = ["Circle", "Triangle", "Square", "Infinity", "Diamond", "S_Shape", "No more movements"]
    var movIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = PracticePresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
        CommonUtils.setCorners(forViews: [VAction, VExample])
        CommonUtils.setShadow(forViews: [VAction, VExample])
        LResult.text = ""
    }

    func initController() {
        showMovement()
    }
    
    // Primary Functions
    func printQuaternion(quat: CMQuaternion){
        x_arr.append(quat.x)
        y_arr.append(quat.y)
        z_arr.append(quat.z)
        w_arr.append(quat.w)
    }
    
    func startQueuedUpdates() {
        if motionManager.isDeviceMotionAvailable {
          self.motionManager.deviceMotionUpdateInterval = 5.0 / 60.0
          self.motionManager.showsDeviceMovementDisplay = true
          self.motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical,
                   to: self.queue, withHandler: { (data, error) in
             // Make sure the data is valid before accessing it.
             if let validData = data {
                // Get the attitude relative to the magnetic north reference frame.
                
                /*print("\n\n\n ---- New Movement  ----")
                print("  attitude =", validData.attitude)
                print("  gravity =", validData.gravity)
                print("  heading =", validData.heading)
                print("  magneticField =", validData.magneticField)
                print("  rotationRate =", validData.rotationRate)
                print("  sensorLocation =", validData.sensorLocation.rawValue)
                print("  userAcceleration =", validData.userAcceleration)*/
                
                //self.printAcceleration(accel: validData.userAcceleration)
                self.printQuaternion(quat: validData.attitude.quaternion)
             }
          })
       }
    }
    
    func checkMovement(){
        // Allow re try
        loader.startAnimating()
        VAction.isEnabled = false
        mPresenter?.checkMovement(movement: movementOptions[movIndex],
                                  x_arr: x_arr,
                                  y_arr: y_arr,
                                  z_arr: z_arr,
                                  w_arr: w_arr){ success in
            if success {
                self.LResult.text = "Excellent!"
                self.VAction.setTitle("Next movement", for: .normal)
                self.movIndex += 1
                self.showMovement()

            } else {
                self.LResult.text = "not successful"
                self.VAction.setTitle("Retry movement", for: .normal)
            }
            self.loader.stopAnimating()
            self.VAction.isEnabled = true
        }
    }
    
   
    // Auxiliar Functions
    func showMovement() {
        if(movIndex >= 6) {
            VAction.isHidden = true
        }
        LMovementTitle.text = movementOptions[movIndex]
        imgMovement.image = UIImage(named: movementOptions[movIndex] + ".png")
        // Change image too
    }
    
    static func getController() -> PracticeController{
        return CommonUtils.getController(withId: "PracticeController") as! PracticeController
    }
    
    func resetDataArrays() {
        x_arr = []
        y_arr = []
        z_arr = []
        w_arr = []
    }
    
    // Click handlers
    @IBAction func onClick(_ sender: Any) {
        if(!isRecording){
            VAction.setTitle("End movement", for: .normal)
            startQueuedUpdates()
            LResult.text = ""
            
        } else {
            motionManager.stopDeviceMotionUpdates()
            checkMovement()
            resetDataArrays()
        }
        isRecording = !isRecording

    }
    
    @IBAction func onSeeExample(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
