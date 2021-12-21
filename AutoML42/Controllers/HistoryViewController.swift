//
//  HistoryViewController.swift
//  AutoML42
//
//  Created by su on 2021/12/21.
//

import UIKit
import CoreData

class HistoryViewController:UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var histories = [History]()
    
    
    override func viewDidLoad() {
        readHistory()
        
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        self.historyCollectionView.reloadData()
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
        print("여기서는..? \(histories.count)")
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryItemCell", for: indexPath) as? HistoryItem else {
                    return UICollectionViewCell()
        }
        
        guard let imageData = histories[indexPath.row].image else {
            return UICollectionViewCell()
        }
        
        let image = UIImage(data: imageData)
        
        cell.itemImage.image = image
        cell.itemUserID.text = histories[indexPath.row].intraID
        
        return cell
    }
}
