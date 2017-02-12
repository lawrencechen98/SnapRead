//
//  ProcessingView.swift
//  SnapRead
//
//  Created by Lawrence Chen on 2/12/17.
//  Copyright © 2017 Lawrence Chen. All rights reserved.
//

import UIKit
import TesseractOCR
import AVFoundation


class ProcessingView: UIViewController, G8TesseractDelegate {

    @IBOutlet var speakButton: UIButton!

    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var processedText: UITextView!
    var processedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        processImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func progressImageRecognition(for tesseract: G8Tesseract!){
        print(tesseract.progress)
    }
    
    func toInt(unsigned: UInt) -> Int {
        
        let signed = (unsigned <= UInt(Int.max)) ?
            Int(unsigned) :
            Int(unsigned - UInt(Int.max) - 1) + Int.min
        
        return signed
    }
    
    func processImage(){
        print("start")
        speakButton.isEnabled = false
        activity.startAnimating()
        if let tesseract = G8Tesseract(language: "eng+chi_tra"){
            tesseract.delegate = self
            tesseract.engineMode = .tesseractOnly
            tesseract.image = processedImage?.g8_blackAndWhite()
            tesseract.recognize()
            processedText.text = tesseract.recognizedText
            activity.stopAnimating()
            speakButton.isEnabled = true
            print("hi")
        }
    }
    @IBAction func soundButton(_ sender: Any) {
        let saying = processedText.text
        let utterance = AVSpeechUtterance(string: saying!)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }

}


