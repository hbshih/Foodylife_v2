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
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        spinner.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            if let inputType = device
            {
                let input = try AVCaptureDeviceInput(device: inputType)
                if (captureSesssion.canAddInput(input))
                {
                    captureSesssion.addInput(input)
                    if (captureSesssion.canAddOutput(cameraOutput))
                    {
                        captureSesssion.addOutput(cameraOutput)
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        
                        previewLayer.frame = cameraView.bounds
                        cameraView.layer.addSublayer(previewLayer)
                        captureSesssion.startRunning()
                    }
                }
            }else
            {
                print("Error catching your camera")
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func shotButtonTapped(_ sender: Any)
    {
        print("Take photo")
        spinner.alpha = 1
        spinner.startAnimating()
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
        captureSesssion.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if let dataImage = photo.fileDataRepresentation()
        {
            print(UIImage(data: dataImage)?.size as Any)
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let imageOriginalOutput = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            let height = CGFloat(imageOriginalOutput.size.height)
            let rect = CGRect(x: 0, y: imageOriginalOutput.size.height - height, width: imageOriginalOutput.size.width , height: height)
            //Cropping the image to the desired square photo
            self.image = cropImage(image: imageOriginalOutput, toRect: rect)
            //Rotate it to the correct direction
            self.image = self.image?.imageRotatedByDegrees(degrees: 90, flip: false)
            performSegue(withIdentifier: "confirmPhotoSegue", sender: nil)
            spinner.stopAnimating()
            spinner.alpha = 0
        } else {
            print("some error here")
        }
    }
    // callBack from take picture
    
    /*
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer)
        {
            print(UIImage(data: dataImage)?.size as Any)
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let imageOriginalOutput = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            let height = CGFloat(imageOriginalOutput.size.height)
            let rect = CGRect(x: 0, y: imageOriginalOutput.size.height - height, width: imageOriginalOutput.size.width , height: height)
            //Cropping the image to the desired square photo
            self.image = cropImage(image: imageOriginalOutput, toRect: rect)
            //Rotate it to the correct direction
            self.image = self.image?.imageRotatedByDegrees(degrees: 90, flip: false)
            performSegue(withIdentifier: "confirmPhotoSegue", sender: nil)
        } else {
            print("some error here")
        }
    }
    */
    //Function for Image Cropping
    func cropImage(image:UIImage, toRect rect:CGRect) -> UIImage
    {
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


