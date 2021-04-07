//
//  PasswordController.swift
//  MovementAuth
//
//  Created by Fran on 03/04/21.
//

import Foundation
import UIKit
import CoreMotion
import KeychainAccess

struct Movement: Encodable {
    let x: [Double]
    let y: [Double]
    let z: [Double]
    let w: [Double]
}

class PasswordController: BaseController, PasswordViewDelegate {
    
    var mPresenter: PasswordPresenter?
    var motionManager = CMMotionManager()
    var queue: OperationQueue = OperationQueue()
    var isRecording = false
    
    @IBOutlet weak var vAction: UIButton!
    @IBOutlet weak var vGetPassword: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var vTOTP: UIView!
    @IBOutlet weak var LTOTP: UILabel!
    
    var x_arr: [Double] = [], y_arr: [Double] = [], z_arr: [Double] = [], w_arr: [Double] = []
    var allMovements: [Movement] = []
    
    let keychain = Keychain(service: "com.frantastic.MovementAuth")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = PasswordPresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
        CommonUtils.setCorners(forViews: [vAction, vGetPassword])
        CommonUtils.setShadow(forViews: [vAction, vGetPassword])
    }

    func initController() {
        
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
                self.printQuaternion(quat: validData.attitude.quaternion)
             }
          })
       }
    }
    
    func getTOTP(randomSequence: [String]) {
        DispatchQueue.global().async {
            do {
                let secret = try self.keychain
                    .authenticationPrompt("Authenticate please")
                    .get("AuthMovementSecretKey")
                DispatchQueue.main.sync {
                    let totp = TOTPAlgorithm.getTOTP(secretKey: secret!, randomSeq: randomSequence)
                    print("TOTP = ", totp)
                    self.LTOTP.text = totp
                    self.vTOTP.isHidden = false
                    self.vAction.setTitle("Restart", for: .normal)
                }
                
            } catch let error {
                print("error storing data = ", error)
            }
        }
        
    }
    
    func getPassword() {
        // Allow re try
        var mSequence = [""]
        loader.startAnimating()
        vAction.isEnabled = false
        mPresenter?.sendAllMovements(allMovements: allMovements) { sequence in
            mSequence = sequence
            
            self.loader.stopAnimating()
            self.vAction.isEnabled = true
            
            print("Sequence = ", mSequence)
            self.getTOTP(randomSequence: mSequence)
        }
    }
    
    func buildMovementData(){
        let movData = Movement(x: x_arr, y: y_arr, z: z_arr, w: w_arr)
        allMovements.append(movData)
    }
   
    // Auxiliar Functions
    static func getController() -> PracticeController{
        return CommonUtils.getController(withId: "PracticeController") as! PracticeController
    }
    
    func restartAll() {
        resetDataArrays()
        vAction.setTitle("Start movement", for: .normal)
    }
    
    func resetDataArrays() {
        x_arr = []
        y_arr = []
        z_arr = []
        w_arr = []
    }
    
    // Click handlers
    
    @IBAction func onAction(_ sender: Any) {
        if(vAction.currentTitle == "Restart") {
            restartAll()
        }
        
        if(!isRecording){
            vAction.setTitle("End movement", for: .normal)
            startQueuedUpdates()
            
        } else {
            vAction.setTitle("Start movement", for: .normal)
            motionManager.stopDeviceMotionUpdates()
            buildMovementData()
            resetDataArrays()
        }
        isRecording = !isRecording
    }
    
    @IBAction func onGetPassword(_ sender: Any) {
        if(allMovements.count == 0){
            showMessage("Make some movements first")
            getTOTP(randomSequence: ["F",
                                     "Y",
                                     "4",
                                     "2"])
            return
        }
        
        if(allMovements.count != 4){
            showMessage("Please make 4 movements")
            return
        }
        getPassword()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
