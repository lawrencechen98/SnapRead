//
//  CameraView.swift
//  SnapRead
//
//  Created by Lawrence Chen on 2/11/17.
//  Copyright © 2017 Lawrence Chen. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    @IBOutlet var processButton: UIButton!
    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCamera()
        captureButton.isHidden = false
        captureButton.isEnabled = true
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        processButton.isHidden = true
        processButton.isEnabled = false
        tempImageView.isHidden = true
    }
    

    @IBAction func didPressTakePhoto(_ sender: Any) {
        takePicture()
    }
    
    @IBAction func didPressDelete(_ sender: UIButton) {
        captureButton.isHidden = false
        captureButton.isEnabled = true
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        processButton.isHidden = true
        processButton.isEnabled = false
        tempImageView.isHidden = true
    }
    
    func takePicture(){
        print("buttonpressed")
        captureButton.isHidden = true
        captureButton.isEnabled = false
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = true
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            if let image = UIImage(data: photoData!){
                tempImageView.image = image
                deleteButton.isEnabled = true
                deleteButton.isHidden = false
                processButton.isEnabled = true
                processButton.isHidden = false
                self.tempImageView.isHidden = false
                print("hey")
            }
        }
        
    }
    
    func loadCamera(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                if (captureSession.canAddOutput(stillImageOutput)) {
                    captureSession.addOutput(stillImageOutput)
                    stillImageOutput.isHighResolutionCaptureEnabled = true
                    captureSession.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
                    captureVideoLayer.frame = self.cameraView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.cameraView.layer.addSublayer(captureVideoLayer)
                }
            }
        }
        catch {
            print(error)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newView = segue.destination as! ProcessingView
        if (segue.identifier == "toProcess"){
            newView.processedImage = tempImageView.image
        }
    }
}







