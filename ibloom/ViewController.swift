//
//  ViewController.swift
//  whatFlower
//
//  Created by shubham on 14/08/20.
//  Copyright © 2020 Shubham Deshmukh. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicker: UIImageView!
    let imagePickerrr = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerrr.delegate = self
        imagePickerrr.allowsEditing = true
        imagePickerrr.sourceType = .camera
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
         
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("connot convert to ciImage")
            }
            detect(image: ciImage)
        imagePicker.image = userPickedImage
        
        imagePickerrr.dismiss(animated: true, completion: nil)
        }
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePickerrr, animated: true, completion: nil)
    }
    
    
    
   
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let classification = request.results?.first as? VNClassificationObservation
            
            self.navigationItem.title = classification?.identifier.capitalized
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
        try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    
}

