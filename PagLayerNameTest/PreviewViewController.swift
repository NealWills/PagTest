//
//  PreviewViewController.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/2.
//

import UIKit
import libpag

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var pagView: PAGView?
    
    var file: String?
    
    var list: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let navHeight = p > 1.8 ? 88 : 64
        
        pagView = PAGView.init(frame: CGRectMake(0, CGFloat(navHeight + 40), self.view.frame.width, 300))
        self.view.addSubview(pagView!)
        pagView?.setRepeatCount(0)
        pagView?.layer.borderColor = UIColor.init(red: 0.6, green: 0.8, blue: 0.7, alpha: 1).cgColor
        pagView?.layer.borderWidth = 1
        pagView?.layer.cornerRadius = 3
        
        self.tableView.register(UINib.init(nibName: "NameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DefaultId")
        
        self.previewFile(file)
        // Do any additional setup after loading the view.
    }
    
    func previewFile(_ file: String?) {
        
        let pathList = file?.components(separatedBy: "/")
        self.titleLabel.text = pathList?.last ?? ""
        
        let pagFile = PAGFile.load(file)
        pagView?.setComposition(pagFile)
        pagView?.play()
        
        guard let count = pagFile?.numChildren() else {
            return
        }
        for i in 0..<count {
            let layer = pagFile?.getLayerAt(Int32(i))
            list.append("[\(i)]" + " " + "[type: \(layer?.layerType().rawValue ?? 0)]" + " " + "[name: \(layer?.layerName() ?? "")]")
        }
        self.tableView.reloadData()
    }

}

extension PreviewViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    
}
