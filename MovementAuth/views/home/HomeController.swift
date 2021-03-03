//
//  HomeController.swift
//  MovementAuth
//
//  Created by Fran on 02/03/21.
//


import Foundation
import UIKit
import AVFoundation

class HomeController: BaseController, HomeViewDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    var mPresenter: HomePresenter?
    
    @IBOutlet weak var vScanCode: UIButton!
    @IBOutlet weak var vBtnsGuard: UIView!
    @IBOutlet weak var btnCloseCamera: UIButton!
    
    @IBOutlet weak var imgQRArea: UIImageView!
    
    
    var video = AVCaptureVideoPreviewLayer()
    var session: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var companyCodeStrings: [String] = []
    var sessionStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter = HomePresenter(v: self)
        initViews()
        initController()
    }
    
    // Init Functions
    func initViews() {
        CommonUtils.setCorners(forViews: [vScanCode])
        CommonUtils.setShadow(forViews: [vScanCode])
    }

    func initController() {
        session = AVCaptureSession()
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    }
    
    // Primary Functions

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
                    print("STRINGS = ", companyCodeStrings)
                    
                    let alert = UIAlertController(title: "¿Quieres suscribirte?", message: "Estás por suscribirte a \(companyCodeStrings[0])", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
                        self.hideCamera()
                    }))
                    alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: { (UIAlertAction) in
                        self.hideCamera()
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
        
    // Auxiliary functions
    
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
    
    func showCongratulations(){
        let alert = UIAlertController(title: "¡Felicidades!", message: "Ahora estás suscrito, recuerda referir a tus amigos para sumar puntos y canjearlos por tus productos favoritos", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showIsSubscribed() {
        let alert = UIAlertController(title: "Lo sentimos", message: "Al parecer ya estás suscrito a esta empresa, para ver a qué empresas estás suscrito ingresa a la sección 'Mis empresas'", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Click Functions
    @IBAction func onScanCode(_ sender: Any) {
        //https://www.youtube.com/watch?v=4Zf9dHDJ2yU
        scanCode()
    }
    
    
    @IBAction func onCloseCamera(_ sender: Any) {
        hideCamera()
    }
    
        
    // Auxiliar Functions
    static func getController() -> HomeController{
        return CommonUtils.getController(withId: "HomeController") as! HomeController
    }
}
