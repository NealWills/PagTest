//
//  EditTextPop.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/4.
//

import Foundation
import UIKit

class EditTextPopPopView: UIView {
    var maskButton: UIButton?
    var view: UIView?
    var domain: String?
    var inputText: UITextField?
    var sureButton: UIButton?
    var domainSureAction: ((_ domain: String?, _ originDomain: String?) -> Void)?
    
    
    func initSubviews() {
        alpha = 0.0

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appdelegate.window?.addSubview(self)

        maskButton = UIButton(frame: bounds)
        addSubview(maskButton!)
        maskButton?.addTarget(self, action: #selector(maskButtonClick(_:)), for: .touchUpInside)
        maskButton?.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 130))
        addSubview(view!)
        view?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 80)
        view?.backgroundColor = UIColor.init(white: 1, alpha: 1)
        
        inputText = UITextField(frame: CGRect(x: 20, y: 20, width: 260, height: 40))
        view?.addSubview(inputText!)
        view?.layer.cornerRadius = 20
        inputText?.placeholder = "修改图层文字"
        inputText?.textColor =  UIColor.init(white: 0.3, alpha: 1)
        inputText?.font = UIFont.systemFont(ofSize: 14)
        inputText?.layer.cornerRadius = 5
        inputText?.layer.borderColor = UIColor.init(white: 0.8, alpha: 1).cgColor
        inputText?.layer.borderWidth = 1
        inputText?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: (10), height: (40)))
        inputText?.keyboardType = .URL
        inputText?.rightView = UIView(frame: CGRect(x: 0, y: 0, width: (10), height: (40)))
        inputText?.leftViewMode = .always
        inputText?.rightViewMode = .always
        
        let placeHolderAtt = NSMutableAttributedString(string: "请输入文字", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.init(white: 0.6, alpha: 1).cgColor])
        inputText?.attributedPlaceholder = placeHolderAtt
        
        sureButton = UIButton(frame: CGRect(x: ((view?.frame.width ?? 0) - 80) / 2, y: 80, width: 80, height: 30))
        view?.addSubview(sureButton!)
        sureButton?.addTarget(self, action: #selector(sureButtonAction(_:)), for: .touchUpInside)
        sureButton?.setTitle("确定", for: .normal)
        sureButton?.layer.cornerRadius = 5
        sureButton?.backgroundColor = UIColor.orange
        
        view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    func show() {

        UIView.animate(withDuration: 0.3, animations: { [self] in
            alpha = 1.0
            view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { [self] finished in
            inputText?.becomeFirstResponder()
        }
    }

    func dismiss() {
        inputText?.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: { [self] in
            alpha = 0.0
            view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { [self] finished in
            removeFromSuperview()
        }
    }
    
    
    
    func showMaskView() {
        let view = UIView(frame: UIScreen.main.bounds)
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appdelegate.window?.addSubview(view)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            view.removeFromSuperview()
        })
    }
    
    //  Converted to Swift 5.7 by Swiftify v5.7.28606 - https://swiftify.com/
    func setDomain(_ domain: String?) {
        self.domain = domain
        inputText?.text = domain
    }

    @objc func maskButtonClick(_ sender: UIButton?) {
        inputText?.resignFirstResponder()
        dismiss()
    }
    
    //  Converted to Swift 5.7 by Swiftify v5.7.28606 - https://swiftify.com/
    @objc func sureButtonAction(_ sender: UIButton?) {
        if inputText?.text?.count ?? 0 < 1 {
//            MYHUDTool.showMessageText("请输入域名")
            return
        }
        if domainSureAction != nil {
            domainSureAction?(inputText?.text ?? "", domain)
        }
        inputText?.resignFirstResponder()
        dismiss()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class EditTextPopPop: UIView {
    
    class func showPop(withDomain domain: String?, result resultBack: @escaping (String?, String?) -> Void) {
        let view = EditTextPopPopView(frame: UIScreen.main.bounds)
        view.domain = domain
        view.domainSureAction = resultBack
        view.show()
    }
    
    
}
