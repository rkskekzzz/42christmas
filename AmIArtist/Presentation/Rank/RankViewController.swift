//
//  RankViewController.swift
//  AmIArtist
//
//  Created by su on 2021/12/23.
//

import UIKit
import CoreData

class RankViewController: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var histories = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    // MARK: - Private
    
    private func configure() {
        self.readHistory()
    }
    
    private func readHistory() {
        guard let context = context else { return }
        
        let request: NSFetchRequest<History> = History.fetchRequest()
        do {
            histories = try context.fetch(request)
            
            histories.forEach{ history in
                print("\(history.intraID ?? "empty...") : \(history.confidence) ")
            }
        } catch {
            print("fetch error \(error)")
        }
    }
    
}

extension RankViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankItemCell", for: indexPath) as? RankItemCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
}
