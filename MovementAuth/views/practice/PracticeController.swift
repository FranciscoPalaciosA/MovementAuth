//
//  PracticeController.swift
//  MovementAuth
//
//  Created by Fran on 02/04/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import CoreMotion
import KeychainAccess

class PracticeController: BaseController, PracticeViewDelegate {
    
    var mPresenter: PracticePresenter?
    var motionManager = CMMotionManager()
    var queue: OperationQueue = OperationQueue()
    var isRecording = false
    
    @IBOutlet weak var VAction: UIButton!
    @IBOutlet weak var VRestart: UIButton!
    @IBOutlet weak var VExample: UIButton!
    @IBOutlet weak var LMovementTitle: UILabel!
    @IBOutlet weak var imgMovement: UIImageView!
    @IBOutlet weak var LResult: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var x_arr: [Double] = [], y_arr: [Double] = [], z_arr: [Double] = [], w_arr: [Double] = []
    var movementOptions = ["Circle", "Square" ] //"Infinity", "Diamond", "S_Shape", "Triangle"]
    var movIndex = 0
    var userId = ""
    
    let keychain = Keychain(service: "com.frantastic.MovementAuth")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = PracticePresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
        CommonUtils.setCorners(forViews: [VAction, VExample, VRestart])
        CommonUtils.setShadow(forViews: [VAction, VExample, VRestart])
        LResult.text = ""
    }

    func initController() {
        movementOptions = movementOptions.shuffled()
        showMovement()
        getUserID()
    }
    
    // Primary Functions
    func getUserID(){
        DispatchQueue.global().async {
            do {
                if let uid = try self.keychain
                    .authenticationPrompt("Authenticate please")
                    .get("AuthMovementUserId") {
                    self.userId = uid
                } else {
                    self.showMessage("Scan your QR Code. If you have scanned it before, please go back to https://movementauth.web.app/ and create your account again.")
                }
                
                
            } catch let error {
                print("error storing data = ", error)
            }
        }
    }
    
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
        mPresenter?.checkMovement(userId: userId, movement: movementOptions[movIndex],
                                  x_arr: x_arr,
                                  y_arr: y_arr,
                                  z_arr: z_arr,
                                  w_arr: w_arr){ success in
            if success {
                self.LResult.text = "Excellent!"
                self.VAction.setTitle("Next movement", for: .normal)
            
                
            } else {
                self.LResult.text = "Oops, please try again..."
                self.VAction.setTitle("Retry movement", for: .normal)
            }
            self.loader.stopAnimating()
            self.VAction.isEnabled = true
        }
    }
    
   
    // Auxiliar Functions
    func showMovement() {
        LMovementTitle.text = movementOptions[movIndex]
        imgMovement.image = UIImage(named: movementOptions[movIndex] + ".png")
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
    
    func showCurrentMoveExample() {
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "mov-"+movementOptions[movIndex], ofType: "mp4")!))
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true)
        vc.player?.play()
    }
    
    // Click handlers
    @IBAction func onClick(_ sender: Any) {
        if(VAction.title(for: .normal) == "Next movement") {
            if(movIndex >= movementOptions.count - 1) {
                movIndex = -1
            }
            
            movIndex += 1
            showMovement()
            LResult.text = ""
            VAction.setTitle("Start movement", for: .normal)
            return
        }
        
        if(!isRecording && VAction.title(for: .normal) != "Next movement"){
            VRestart.isHidden = false
        }
        
        if(!isRecording){
            VAction.setTitle("End movement", for: .normal)
            startQueuedUpdates()
            LResult.text = ""
        } else {
            motionManager.stopDeviceMotionUpdates()
            checkMovement()
            resetDataArrays()
            VRestart.isHidden = true
        }
        isRecording = !isRecording

    }
    
    func restart() {
        motionManager.stopDeviceMotionUpdates()
        resetDataArrays()
        VAction.setTitle("Start movement", for: .normal)
        VRestart.isHidden = true
        isRecording = !isRecording
    }
    
    @IBAction func onRestart(_ sender: Any) {
        restart()
    }
    
    @IBAction func onSeeExample(_ sender: Any) {
        showCurrentMoveExample()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
