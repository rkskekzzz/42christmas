//
//  RankItemCell.swift
//  AmIArtist
//
//  Created by su on 2021/12/23.
//

import UIKit

class RankItemCell: UITableViewCell {
    static let identifier = "RankItemCell"
    
    private var rankLabel = UILabel()
    private var idLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    func update(with id: String) {
        self.idLabel.text = id
    }
    
    private func configure() {
        self.addSubview(self.idLabel)
        self.idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.idLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.idLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.idLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(self.rankLabel)
        self.rankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.rankLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.rankLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.rankLabel.leadingAnchor.constraint(equalTo: self.idLabel.trailingAnchor),
            self.rankLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
