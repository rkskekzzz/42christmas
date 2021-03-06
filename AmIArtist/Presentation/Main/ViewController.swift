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
    static let showRankSegueIdentifier = "ShowRankSegue"
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var detactButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var rankButton: UIButton!
    
    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let picker = UIImagePickerController()
    
    private var isClearButtonTabbed = false
    private var resultText: String = ""
    private var userID: String?
    private var confidence: Float = 0
    
    // MARK: - UIViewController
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showHistorySegueIdentifier,
           segue.destination as? HistoryViewController != nil,
           userID != nil {
//            destination.configure() {
            // 클로저 함수
                print("\n\nview is changed!\n\n")
//            }
        } else if segue.identifier == Self.showRankSegueIdentifier, segue.destination as? RankViewController != nil {
            print("show rank view controller!")
        }
    }
    // MARK: - Private
    
    private func configure() {
        self.configureButton()
        self.configureImageView()
        self.picker.delegate = self
    }
    
    private func configureButton() {
        self.addImageButton.layer.cornerRadius = 0.5 * addImageButton.bounds.size.width
        self.addImageButton.clipsToBounds = true
        self.addImageButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        self.addImageButton.setTitle("이미지 추가", for: .normal)
        self.addImageButton.setTitleColor(UIColor.white, for: .normal)
        
        self.clearButton.layer.cornerRadius = 12
        self.clearButton.clipsToBounds = true
        self.clearButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.clearButton.tintColor = UIColor.white
        
        self.historyButton.layer.cornerRadius = 12
        self.historyButton.clipsToBounds = true
        self.historyButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.historyButton.tintColor = UIColor.white
        
        self.detactButton.layer.cornerRadius = 20
        self.detactButton.clipsToBounds = true
        self.detactButton.backgroundColor = UIColor.purple.withAlphaComponent(0.8)
        self.detactButton.titleLabel?.text = "Start!"
        NSLayoutConstraint.activate([
            self.detactButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 40),
            self.detactButton.widthAnchor.constraint(equalToConstant: 130),
            self.detactButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        self.rankButton.layer.cornerRadius = 12
        self.rankButton.clipsToBounds = true
        self.rankButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.rankButton.tintColor = UIColor.white
    }
    
    private func configureImageView() {
        let backgroundImage = UIImage(named: "background2.jpg")
        let popupImage = UIImage(named: "popup.png")
        
        self.backgroundImageView.image = backgroundImage
        self.backgroundImageView.contentMode = .scaleAspectFill
        
        self.popupImageView.image = popupImage
        self.popupImageView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.popupImageView.isHidden = true
        
    }
    
    private func showResult(by check: Bool) {
        self.configurePopupImage(by: check)
        self.popupImageView.fadeInOut()
        self.detactButton.fadeOutIn()
    }
    
    private func configurePopupImage(by check: Bool) {
        if check {
            self.popupImageView.image = UIImage(named: "success.png")
        } else {
            self.popupImageView.image = UIImage(named: "fail.png")
        }
    }
    
    private func saveHistory() {
        guard let context = context else { return }
        
        do {
            try context.save()
        } catch {
            print("save error")
        }
    }
    
    private func openLibrary(){
        self.picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    private func openCamera(){
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            self.picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    private func showTextInputAlert(saveWithImage imageData: Data?, check: Bool) {
        guard let imageData = imageData else { return }
        let alert = UIAlertController(title: "intra ID를 입력해 주세요!", message: "", preferredStyle: .alert)
        
        weak var weakSelf = self
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            guard let strongSelf = weakSelf else { return }
            guard let context = strongSelf.context else { return }
            guard let textFields = alert.textFields else { return }
            
            let history = History(context: context)
            
            history.id = UUID()
            history.image = imageData
            history.intraID = textFields[0].text
            history.check = check
            history.confidence = strongSelf.confidence
            
            strongSelf.saveHistory()
            strongSelf.showResult(by: check)
        }
        
        alert.addTextField()
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions

    @IBAction func rankButtonTabbed(_ sender: Any) {
        performSegue(withIdentifier: Self.showRankSegueIdentifier, sender: self)
    }
    @IBAction func historyButtonTabbed(_ sender: Any) {
        performSegue(withIdentifier: Self.showHistorySegueIdentifier, sender: self)
    }
    
    @IBAction func detectButtonTabbed(_ sender: Any) {
        guard let image = backgroundImageView.image else { return }
        
        // [START init_label]
        let options = ImageLabelerOptions()
        options.confidenceThreshold = 0.7
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
            strongSelf.confidence = labels[0].confidence

//            strongSelf.resultText = labels.map { label -> String in
//              return "Label: \(label.text), Confidence: \(label.confidence), Index: \(label.index)"
//            }.joined(separator: "\n")

//            strongSelf.showResult()
            
            let imageData = image.jpegData(compressionQuality: 1.0)
            let check  = labels[0].text == "Christmas" ? true : false
            
            strongSelf.showTextInputAlert(saveWithImage: imageData, check: check)
        }
        
    }
    
    @IBAction func clearButtonTabbed(_ sender: Any) {
        isClearButtonTabbed.toggle()
        
        let isHidden = isClearButtonTabbed
        
        self.addImageButton.isHidden = isHidden
        self.detactButton.isHidden = isHidden
    }
    
    @IBAction func addImageButtonTabbed(_ sender: Any) {
        let alert =  UIAlertController(title: "사진을 선택하세요", message: "분석할 이미지 설정", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { _ in
            self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
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
        UIView.animate(withDuration: 2) { [weak self] in
            self?.alpha = 1
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 2, animations: {
                self?.alpha = 0
            }, completion: { _ in
                self?.isHidden = true
            })
        }
    }
    
    func fadeOutIn() {
        self.alpha = 1
        UIView.animate(withDuration: 2) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 2, animations: {
                self?.alpha = 1
            }, completion: { _ in
            })
        }
    }
}
