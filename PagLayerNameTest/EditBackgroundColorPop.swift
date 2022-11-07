//
// Created by Neal on 2022/11/9.
//

import Foundation
import UIKit

fileprivate class EditBackgroundColorPopContentView: UIView {

    var maskButton: UIButton?
    var view: UIView?
    var sureButton: UIButton?

    var colors: [CGColor]!
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    var locations: [NSNumber]!
    var sureAction: (([CGColor], CGPoint, CGPoint, [NSNumber]) -> Void)!

    var colorView: EditBackgroundColorCurrentColorView?

    func initSubviews() {
        alpha = 0.0

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.addSubview(self)

        weak var weakSelf = self

        maskButton = UIButton(frame: bounds)
        addSubview(maskButton!)
        maskButton?.addTarget(self, action: #selector(maskButtonClick(_:)), for: .touchUpInside)
        maskButton?.backgroundColor = UIColor.init(white: 0, alpha: 0.2)

        view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
        addSubview(view!)
        view?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        view?.backgroundColor = UIColor.init(white: 1, alpha: 1)
        view?.layer.cornerRadius = 10;

        self.colorView = EditBackgroundColorCurrentColorView.init(frame: CGRect.init(x: 20, y: 20, width: 260, height: 260))
        self.view?.addSubview(self.colorView!)
        self.colorView?.configureDefaultLayer(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
        self.colorView?.selectAction =  { colors, startPoint, endPoint, locations in
            weakSelf?.colors = colors
            weakSelf?.startPoint = startPoint
            weakSelf?.endPoint = endPoint
            weakSelf?.locations = locations
        }

        sureButton = UIButton(frame: CGRect(x: ((view?.frame.width ?? 0) - 80) / 2, y: 300, width: 80, height: 30))
        view?.addSubview(sureButton!)
        sureButton?.addTarget(self, action: #selector(sureButtonAction(_:)), for: .touchUpInside)
        sureButton?.setTitle("确定", for: .normal)
        sureButton?.layer.cornerRadius = 5
        sureButton?.backgroundColor = UIColor.orange

        view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let colorViewLeading = self.colorView?.frame.origin.x ?? 0
        let colorViewTop = self.colorView?.frame.origin.y ?? 0
        let colorViewTrailing = colorViewLeading + (self.colorView?.frame.size.width ?? 0)
        let colorViewBottom = colorViewTop + (self.colorView?.frame.size.height ?? 0)
        if point.x > colorViewLeading - 20
                   && point.y > colorViewTop - 20
                   && point.x < colorViewTrailing + 20
                   && point.y < colorViewBottom + 20 {
            return self.colorView
        }
        return super.hitTest(point, with: event)
    }

    func show() {

        UIView.animate(withDuration: 0.3, animations: { [self] in
            alpha = 1.0
            view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { [self] finished in

        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            alpha = 0.0
            view?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { [self] finished in
            removeFromSuperview()
        }
    }

    func showMaskView() {
        let view = UIView(frame: UIScreen.main.bounds)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.window?.addSubview(view)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            view.removeFromSuperview()
        })
    }

    @objc func maskButtonClick(_ sender: UIButton?) {
        dismiss()
    }

    @objc func sureButtonAction(_ sender: UIButton?) {
        self.sureAction(self.colors, self.startPoint, self.endPoint, self.locations)
        dismiss()
    }

    convenience init(colors: [CGColor],
                     startPoint: CGPoint,
                     endPoint: CGPoint,
                     locations: [NSNumber],
                     sureAction:
                             @escaping ([CGColor], CGPoint, CGPoint, [NSNumber]) -> Void
    ) {
        self.init(frame: UIScreen.main.bounds)
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.locations = locations
        self.sureAction = sureAction
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EditBackgroundColorPop: NSObject {

    class func show(colors: [CGColor],
                    startPoint: CGPoint,
                    endPoint: CGPoint,
                    locations: [NSNumber],
                    sureAction:
                            @escaping ([CGColor], CGPoint, CGPoint, [NSNumber]) -> Void
    ) {
        let pop = EditBackgroundColorPopContentView.init(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations, sureAction: sureAction)
        pop.show()
    }

}