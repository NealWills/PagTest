//
//  ViewController.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/2.
//

import UIKit
import UniformTypeIdentifiers

class ViewController: UIViewController {
    
    var list: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.append("pet_levelUp_animate")
        list.append("pet_levelUpThan_animate")
        list.append("pet_normalLevelUp_animate")
        list.append("pet_normalLevelUpThan_animate")
        
        self.tableView.register(UINib.init(nibName: "NameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DefaultId")
        
    }
    
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "DefaultId"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? NameTableViewCell
        cell?.title = list[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let file = list[indexPath.row]
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController else {
            return
        }
        let filePath = Bundle.main.path(forResource: file, ofType: "")
        vc.file = filePath
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
}
