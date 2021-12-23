//
//  HistoryItem.swift
//  AutoML42
//
//  Created by su on 2021/12/21.
//

import UIKit

class HistoryItemViewCell: UICollectionViewCell {
    static let identifier = "HistoryItemCell"
    private var itemImage = UIImageView()
    private var itmeUserID: PaddingLabel = {
        let label = PaddingLabel()
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.backgroundColor = UIColor.green.withAlphaComponent(0.6)
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
    
    func update(with image: UIImage?, userID: String?, check: Bool) {
        guard let image = image, let userID = userID else { return }

        self.itemImage.image = image
        self.itmeUserID.text = userID
        if !check {
            self.itmeUserID.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        }
    }
    
    private func configure() {
        self.addSubview(self.itemImage)
        self.itemImage.translatesAutoresizingMaskIntoConstraints = false
        self.itemImage.contentMode = .scaleAspectFill
        self.itemImage.clipsToBounds = true
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
