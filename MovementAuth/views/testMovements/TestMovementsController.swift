//
//  TestMovementsController.swift
//  MovementAuth
//
//  Created by Fran on 04/03/21.
//

import Foundation
import CoreMotion
import UIKit

class TestMovementsController: BaseController, TestMovementsViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var mPresenter: TestMovementsPresenter?
    var motionManager = CMMotionManager()
    var queue: OperationQueue = OperationQueue()
    var isRecording = false
    var movementOptions = ["Circle", "Triangle", "H_Line", "V_Line", "Square", "D_Line", "Diamond", "S_Shape"]
    
    var movement = "Circle"
    var x_arr: [Double] = [], y_arr: [Double] = [], z_arr: [Double] = [], w_arr: [Double] = []
    
    @IBOutlet weak var vAction: UIButton!
    @IBOutlet weak var movementPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = TestMovementsPresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
        self.movementPicker.delegate = self
        self.movementPicker.dataSource = self
    }

    func initController() {
        print("If its available = ", motionManager.isDeviceMotionAvailable)
        
    }
    
    func printAcceleration(accel: CMAcceleration){
        print(accel.x, accel.y, accel.z)
    }
    
    func printQuaternion(quat: CMQuaternion){
        x_arr.append(quat.x)
        y_arr.append(quat.y)
        z_arr.append(quat.z)
        w_arr.append(quat.w)
    }
    
    
    // Primary Functions
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
    
   
    // Auxiliar Functions
    static func getController() -> TestMovementsController{
        return CommonUtils.getController(withId: "TestMovementsController") as! TestMovementsController
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
            vAction.setTitle("End movement", for: .normal)
            startQueuedUpdates()
            movementPicker.isHidden = true
            
        } else {
            vAction.setTitle("Start movement", for: .normal)
            motionManager.stopDeviceMotionUpdates()
            movementPicker.isHidden = false
            mPresenter?.saveDataOnDB(movement: movement, x_arr: x_arr, y_arr: y_arr, z_arr: z_arr, w_arr: w_arr)
            resetDataArrays()
        }
        isRecording = !isRecording

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return movementOptions.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return movementOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        movement = movementOptions[row]
    }
    
}
