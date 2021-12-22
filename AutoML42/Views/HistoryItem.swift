//
//  HistoryItem.swift
//  AutoML42
//
//  Created by su on 2021/12/21.
//

import UIKit

class HistoryItem: UICollectionViewCell {
    static let identifier = "HistoryItemCell"
    private var itemImage = UIImageView()
    private var itmeUserID: PaddingLabel = {
        let label = PaddingLabel()
        label.layer.cornerRadius =  10
        label.clipsToBounds = true
        label.font.withSize(0.7)
        label.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        label.textColor = UIColor.white
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func update(with image: UIImage, userID: String, check: Bool) {
        self.itemImage.image = image
        self.itmeUserID.text = userID
        if !check {
            self.itmeUserID.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        }
    }
    
    private func configure() {
        self.addSubview(self.itemImage)
        self.itemImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.itemImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.itemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.itemImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.itemImage.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
        self.addSubview(self.itmeUserID)
        self.itmeUserID.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.itmeUserID.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.itmeUserID.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
    }
}
