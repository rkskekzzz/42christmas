//
//  HistoryViewController.swift
//  AutoML42
//
//  Created by su on 2021/12/21.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    // MARK: - UIView Outlet
    
    private var historyCollectionView: HistoryCollectionView!

    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var layout: UICollectionViewFlowLayout {
        let width = (view.frame.width )/3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    var histories = [History]()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.historyCollectionView.reloadData()
    }
    
    // MARK: - Private
    
    private func configure() {
        self.bind()
        self.readHistory()
        self.configureHistoryCollectionView()
    }
    
    private func bind() {
        historyCollectionView = HistoryCollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }
    
    private func configureHistoryCollectionView() {
        self.view.addSubview(self.historyCollectionView)
        self.historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        self.historyCollectionView.register(HistoryItem.self, forCellWithReuseIdentifier: HistoryItem.identifier)
        NSLayoutConstraint.activate([
            self.historyCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.historyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.historyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.historyCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func readHistory() {
        let request: NSFetchRequest<History> = History.fetchRequest()
        do {
            histories = try context.fetch(request)
        } catch {
            print("fetch error \(error)")
        }
    }
}

extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource & Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryItemCell", for: indexPath) as? HistoryItem else {
                    return UICollectionViewCell()
        }
        
        guard let imageData = histories[indexPath.row].image else {
            return UICollectionViewCell()
        }
        
        let image = UIImage(data: imageData)!
        let id = histories[indexPath.row].intraID!
        let check = histories[indexPath.row].check
        
        cell.update(with: image, userID: id, check: check)
        
        return cell
    }
}
