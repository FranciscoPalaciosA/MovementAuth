//
//  HomeController.swift
//  MovementAuth
//
//  Created by Fran on 02/03/21.
//


import Foundation
import UIKit
import AVFoundation
import KeychainAccess

class HomeController: BaseController, HomeViewDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    var mPresenter: HomePresenter?
    
    @IBOutlet weak var vScanCode: UIButton!
    @IBOutlet weak var vTestMovements: UIButton!
    @IBOutlet weak var vBtnsGuard: UIView!
    @IBOutlet weak var vStartMovements: UIButton!
    @IBOutlet weak var btnCloseCamera: UIButton!
    
    @IBOutlet weak var imgQRArea: UIImageView!
    
    
    var video = AVCaptureVideoPreviewLayer()
    var session: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var companyCodeStrings: [String] = []
    var sessionStarted = false
    var userEmail = ""
    var userSecret = ""
    
    let keychain = Keychain(service: "com.frantastic.MovementAuth")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = HomePresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
        CommonUtils.setCorners(forViews: [vScanCode, vTestMovements, vStartMovements])
        CommonUtils.setShadow(forViews: [vScanCode, vTestMovements, vStartMovements])
    }

    func initController() {
        session = AVCaptureSession()
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    }
    
    // Primary Functions
    
    func storeSecret() {
        DispatchQueue.global().async {
            do {
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(self.userSecret, key: "AuthMovementSecretKey")
                    
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(self.userEmail, key: "AuthMovementEmail")
            } catch let error {
                print("error storing data = ", error)
            }
        }
        
        /*
         To recover
         DispatchQueue.global().async {
             do {
                 let secret = try self.keychain
                     .authenticationPrompt("Authenticate please")
                     .get("AuthMovementSecretKey")
                     print("Secret = ", secret!)
             } catch let error {
                 print("error storing data = ", error)
             }
         }
         */
    }

    func scanCode(){
        
        if(!sessionStarted){
            do{
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                session!.addInput(input)
            } catch {
                print("ERROR")
            }
            
            let output = AVCaptureMetadataOutput()
            session?.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            sessionStarted = true
        }
        
        showCamera()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr {
                    
                    companyCodeStrings = object.stringValue!.components(separatedBy: "-")
                    
                    if(!checkQRString(str: object.stringValue!)) {
                        showMessage("Wrong QR, please scan a correct code.")
                        self.hideCamera()
                        return
                    }

                    let alert = UIAlertController(title: "Link an account", message: "Do you wish to link your  \(userEmail) account. Any previous linked account will be overwritten.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
                        self.hideCamera()
                    }))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                        self.storeSecret()
                        self.hideCamera()
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getTOTP() {
        DispatchQueue.global().async {
            do {
                let secret = try self.keychain
                    .authenticationPrompt("Authenticate please")
                    .get("AuthMovementSecretKey")
                
                let totp = TOTPAlgorithm.testAlgorithm()
                print("totp = ", totp)
            } catch let error {
                print("error storing data = ", error)
            }
        }
    }
        
    // Auxiliary functions
    func checkQRString(str: String) -> Bool {
        let elements = str.components(separatedBy: "-")
        if(elements.count != 2){
            return false
        }
        
        let email = elements[0].components(separatedBy: ":")
        if(email.count != 2 || email[0] != "email"){
            return false
        }
        
        let secret = elements[1].components(separatedBy: ":")
        if(secret.count != 2 || secret[0] != "secret"){
            return false
        }
        userEmail = email[1]
        userSecret = secret[1]
        return true
    }
    
    func showCamera(){
        vBtnsGuard.isHidden = false
        video = AVCaptureVideoPreviewLayer(session: session!)
        video.frame = vBtnsGuard.layer.bounds
        vBtnsGuard.layer.addSublayer(video)
        vBtnsGuard.addSubview(btnCloseCamera)
        vBtnsGuard.addSubview(imgQRArea)
        session?.startRunning()
        
    }
    
    func hideCamera(){
        session?.stopRunning()
        video.removeFromSuperlayer()
        vBtnsGuard.isHidden = true
    }
        
    // Click Functions
    @IBAction func onScanCode(_ sender: Any) {
        //https://www.youtube.com/watch?v=4Zf9dHDJ2yU
        scanCode()
    }
    
    @IBAction func onTestMovements(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TestMovementsController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TestMovementsController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onStartMovements(_ sender: Any) {
        getTOTP()
    }
    
    @IBAction func onCloseCamera(_ sender: Any) {
        hideCamera()
    }
    
        
    // Auxiliar Functions
    static func getController() -> HomeController{
        return CommonUtils.getController(withId: "HomeController") as! HomeController
    }
}
