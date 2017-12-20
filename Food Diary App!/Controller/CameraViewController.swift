//
//  CameraViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var backCAmera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    
    var image : UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCAptuireSession()
        
        
    }
    
    func setupCaptureSession()
    {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    func setupDevice()
    {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices
        {
            if device.position == AVCaptureDevice.Position.back
            {
                backCAmera = device
            }else
            {
                frontCamera = device
            }
            currentCamera = backCAmera
        }
        
        
    }
    func setupInputOutput()
    {
        do{
            if let camera = currentCamera
            {
                let captureDeviceInput = try AVCaptureDeviceInput(device: camera)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            }
        }catch
        {
            print(error)
        }
        
    }
    func setupPreviewLayer()
    {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCAptuireSession()
    {
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self as! AVCapturePhotoCaptureDelegate)
        
        //performSegue(withIdentifier: "showphotoSugue", sender: nil)
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showphotoSugue"
        {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.preImage = image!
        }
    }
 */
    
}

extension ViewController: AVCapturePhotoCaptureDelegate
{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation()
        {
            print(imageData)
           // image = UIImage(data: imageData)
            /*
            performSegue(withIdentifier: "showphotoSugue", sender: nil)
 */
        }
    }
}


