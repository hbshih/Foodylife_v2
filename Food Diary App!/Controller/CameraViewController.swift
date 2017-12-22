//
//  CameraViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSesssion : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var image: UIImage?

    //@IBOutlet weak var cameraView: UIView!
      @IBOutlet weak var cameraView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let input = try? AVCaptureDeviceInput(device: device!) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    
                    previewLayer.frame = cameraView.bounds
                    cameraView.layer.addSublayer(previewLayer)
                    captureSesssion.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    
    @IBAction func shotButtonTapped(_ sender: Any)
    {
        print("Take photo")
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // callBack from take picture
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size as Any)
        
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            
            var image_A = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
          //  self.image = shootedImage.cropToRect(rect: CGRect(x: 150.0, y: 200.0, width: 100.0, height: 100.0))
            
            let height = CGFloat(image_A.size.height)
            let rect = CGRect(x: 0, y: image_A.size.height - height, width: image_A.size.width , height: height)
            self.image = cropImage(image: image_A, toRect: rect)
            self.image = self.image?.imageRotatedByDegrees(degrees: 90, flip: false)
            
            performSegue(withIdentifier: "confirmPhotoSegue", sender: nil)
            
            // self.capturedImage.image = image
            
        } else {
            print("some error here")
        }
    }
    
    func cropImage(image:UIImage, toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "confirmPhotoSegue"
        {
            if let ConfirmPhotoVC = segue.destination as? ConfirmPhotoViewController
            {
                ConfirmPhotoVC.image = image
            }
        }
    }
    
}


