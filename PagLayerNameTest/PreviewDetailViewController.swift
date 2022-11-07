//
//  PreviewDetailViewController.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/2.
//

import UIKit
import libpag

class PreviewDetailViewController: UIViewController {

    weak var pagFile: PAGFile?
    
    var filePath: String?
    
    var pagView: PAGView?

    var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let layer = self.gradientLayer {
            layer.frame = self.view.bounds
            self.view.layer.addSublayer(layer)
        }

        let p = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let navHeight:CGFloat = p > 1.8 ? 88 : 64
                
        pagView = PAGView.init(frame: CGRect.init(x: 0, y: navHeight, width: self.view.frame.width, height: self.view.frame.height - navHeight))
        self.view.addSubview(pagView!)
        pagView?.setRepeatCount(0)


        if let pagFile = self.pagFile {
            pagView?.setComposition(pagFile)
            pagView?.play()
        } else if let pagFile = PAGFile.load(filePath) {
            pagView?.setComposition(pagFile)
            pagView?.play()
        }

    }
    

}
