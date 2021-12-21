//
//  HistoryViewController.swift
//  AutoML42
//
//  Created by su on 2021/12/21.
//

import UIKit
import CoreData

class HistoryViewController:UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var histories = [History]()
    
    override func viewDidLoad() {
        readHistory()
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
