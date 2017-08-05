//
//  ViewController.swift
//  Face Recognization
//
//  Created by SaiSandeep on 05/08/17.
//  Copyright © 2017 SaiSandeep. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "sample1") else {
            return
        }
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        view.addSubview(imageView)
        
        
        let request = VNDetectFaceRectanglesRequest { (req, error) in
            if let error = error  {
                print("Failed to detect faces",error)
                return
            }
            guard let observations = req.results as? [VNFaceObservation]
                else { fatalError("unexpected result type") }
            
            observations.forEach({ (observation) in
                DispatchQueue.main.async {
                    print(observation.boundingBox)
                    let x = self.view.frame.width * observation.boundingBox.origin.x
                    let width = self.view.frame.width * observation.boundingBox.size.width
                    let height = scaledHeight * observation.boundingBox.size.height
                    let y = scaledHeight * (1 - observation.boundingBox.origin.y) - height
                    let redSquare = UIView()
                    redSquare.backgroundColor = UIColor.clear
                    redSquare.layer.borderColor = UIColor.red.cgColor
                    redSquare.layer.borderWidth = 3.0
                    redSquare.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redSquare)
                }
            })
            
        }
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch let reqError {
                print("Error in req",reqError)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
























