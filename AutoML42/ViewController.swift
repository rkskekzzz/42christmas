//
//  ViewController.swift
//  AutoML42
//
//  Created by su on 2021/12/18.
//

import UIKit
import MLImage
import MLKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultsTextLabel: UILabel!
    
    var resultText: String = ""
    let picker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        let image2 = UIImage(named: "test")
        imageView.image = image2
        titleLabel.text = "hello world"
    }
    
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
        }
        else {
            print("Camera not available")
        }
    }

    // MARK: - IBActions

    @IBAction func detectButtonTabbed(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        let options = ImageLabelerOptions()
        options.confidenceThreshold = 0.7
        
        // [START init_label]
        let onDeviceLabeler = ImageLabeler.imageLabeler(options: options)
        // [END init_label]

        // Initialize a `VisionImage` object with the given `UIImage`.
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        weak var weakSelf = self
        onDeviceLabeler.process(visionImage) { labels, error in
            guard let strongSelf = weakSelf else {
                print("self is nil")
                return
            }
            guard error == nil, let labels = labels, !labels.isEmpty else {
              // [START_EXCLUDE]
              let errorString = error?.localizedDescription ?? "test message"
                strongSelf.resultText = "On-Device label detection failed with error: \(errorString)"
                strongSelf.showResult()
              // [END_EXCLUDE]
              return
            }
            
            labels.forEach{ label in
                print("label : \(label)")
            }
            
            strongSelf.resultText = labels.map { label -> String in
              return "Label: \(label.text), Confidence: \(label.confidence), Index: \(label.index)"
            }.joined(separator: "\n")
            strongSelf.showResult()
        
        }
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            print("in library")
            self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            print("in camera")
            self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Private
    
    private func showResult() {
        resultsTextLabel.text = resultText
    }
}

extension ViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}




