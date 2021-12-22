//
//  ViewController.swift
//  AutoML42
//
//  Created by su on 2021/12/18.
//

import UIKit
import MLImage
import MLKit
import CoreData

class ViewController: UIViewController {
    static let showHistorySegueIdentifier = "ShowHistorySegue"
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultsTextLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    
    
    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let picker = UIImagePickerController()
    
    private var resultText: String = ""
    private var userID: String?
    
    // MARK: - UIViewController
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showHistorySegueIdentifier,
           let _ = segue.destination as? HistoryViewController,
            let _ = userID {
//            destination.configure() {
                print("\n\nview is changed!\n\n")
//            }
        }
    }
    // MARK: - Private
    
    private func configure() {
        self.configureButton()
        self.configureImageView()
        picker.delegate = self
    }
    
    private func saveHistory() {
        do {
            try context.save()
        } catch {
            print("save error")
        }
    }
    
    private func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }
    
    private func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
        }
        else {
            print("Camera not available")
        }
    }
    
    private func configurePopupImage(by check: Bool) {
        if check {
            self.popupImageView.image = UIImage(named: "popup.png")
        } else {
            self.popupImageView.image = UIImage(named: "fail.png")
        }
    }
    
    private func showResult(by check: Bool) {
        self.configurePopupImage(by: check)
        popupImageView.fadeInOut()
    }
    
    private func showTextInputAlert(saveWithImage imageData: Data?, check: Bool) {
        guard let imageData = imageData else { return }
        let alert = UIAlertController(title: "intra ID를 입력해 주세요!", message: "", preferredStyle: .alert)
        
        weak var weakSelf = self
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard let strongSelf = weakSelf else { return }
            guard let textFields = alert.textFields else { return }
            
            let history = History(context: strongSelf.context)
            
            history.id = UUID()
            history.image = imageData
            history.intraID = textFields[0].text
            history.check = check
            
            strongSelf.saveHistory()
            strongSelf.showResult(by: check)
        }
        
        alert.addTextField { textField in
            textField.textColor = .black
        }
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureButton() {
        addImageButton.layer.cornerRadius = 0.5 * addImageButton.bounds.size.width
        addImageButton.clipsToBounds = true
        addImageButton.layer.borderWidth = 1.0
        addImageButton.layer.borderColor = UIColor.white.cgColor
        addImageButton.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        addImageButton.titleLabel?.textColor = UIColor.white
    }
    
    private func configureImageView() {
        let backgroundImage = UIImage(named: "background2.jpg")
        let popupImage = UIImage(named: "popup.png")
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        
        popupImageView.image = popupImage
        popupImageView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        popupImageView.isHidden = true
        
    }

    // MARK: - IBActions

    @IBAction func historyButtonTabbed(_ sender: Any) {
        performSegue(withIdentifier: Self.showHistorySegueIdentifier, sender: self)
    }
    
    @IBAction func detectButtonTabbed(_ sender: Any) {
        guard let image = backgroundImageView.image else { return }
        
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
              let errorString = error?.localizedDescription ?? "localizedDescription Failed!"
                strongSelf.resultText = "On-Device label detection failed with error: \(errorString)"
                print(strongSelf.resultText)
              // [END_EXCLUDE]
              return
            }
            
            strongSelf.resultText = labels[0].text
            
//            strongSelf.resultText = labels.map { label -> String in
//              return "Label: \(label.text), Confidence: \(label.confidence), Index: \(label.index)"
//            }.joined(separator: "\n")

            //            strongSelf.showResult()
            
            let imageData = image.jpegData(compressionQuality: 1.0)
            let check  = labels[0].text == "Christmas" ? true : false
            
            strongSelf.showTextInputAlert(saveWithImage: imageData, check: check)
        }
        
    }
    
    @IBAction func addImageButtonTabbed(_ sender: Any) {
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
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            backgroundImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    // MARK: - UIView extension
    
    func fadeInOut() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 3) { [weak self] in
            self?.alpha = 1
        } completion: { [weak self] (isFinish) in
            UIView.animate(withDuration: 3, animations: {
                self?.alpha = 0
            }, completion: { (isFisish) in
                self?.isHidden = true
            })
        }
    }
}



