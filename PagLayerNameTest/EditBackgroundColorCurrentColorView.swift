//
// Created by Neal on 2022/11/9.
//

import Foundation
import UIKit

class EditBackgroundColorCurrentColorView: UIView {

    private var gradientLayer: CAGradientLayer?

    var colorPoint0: UIView?
    var colorPoint1: UIView?

    var selectAction: (([CGColor], CGPoint, CGPoint, [NSNumber]) -> Void)?

    enum CurrentStatus {
        case none
        case moveColorPoint0
        case moveColorPoint1
    }

    var currentStatus: CurrentStatus = .none

    var colors: [CGColor]! {
        didSet {
            self.gradientLayer?.colors = colors
        }
    }
    var startPoint: CGPoint! {
        didSet {
            self.gradientLayer?.startPoint = startPoint
        }
    }
    var endPoint: CGPoint! {
        didSet {
            self.gradientLayer?.endPoint = endPoint
        }
    }
    var locations: [NSNumber]! {
        didSet {
            self.gradientLayer?.locations = locations
        }
    }

    private func initSubviews() {
        self.gradientLayer = CAGradientLayer.init()
        self.layer.addSublayer(self.gradientLayer!)

        let colors = [
            UIColor.init(white: 0, alpha: 1).cgColor,
            UIColor.init(white: 1, alpha: 1).cgColor,
        ]

        self.gradientLayer?.frame = self.bounds
        self.gradientLayer?.colors = colors
        self.gradientLayer?.locations = [0, 1]
        self.gradientLayer?.startPoint = CGPoint.init(x: 0, y: 1)
        self.gradientLayer?.endPoint = CGPoint.init(x: 1, y: 0)

        self.colorPoint0 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 16, height: 16))
        self.addSubview(self.colorPoint0!)
        self.colorPoint0?.layer.cornerRadius = 8
        self.colorPoint0?.layer.borderColor = UIColor.init(white: 1, alpha: 0.5).cgColor
        self.colorPoint0?.layer.borderWidth = 2
        self.colorPoint0?.backgroundColor = UIColor.init(cgColor: colors[0])
        self.colorPoint0?.center = CGPoint.init(x: 0, y: self.frame.height)

        self.colorPoint1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 16, height: 16))
        self.addSubview(self.colorPoint1!)
        self.colorPoint1?.layer.cornerRadius = 8
        self.colorPoint1?.layer.borderColor = UIColor.init(white: 0, alpha: 0.5).cgColor
        self.colorPoint1?.layer.borderWidth = 2
        self.colorPoint1?.backgroundColor = UIColor.init(cgColor: colors[1])
        self.colorPoint1?.center = CGPoint.init(x: self.frame.width, y: 0)

    }

    func configureDefaultLayer(colors: [CGColor]!, startPoint: CGPoint!, endPoint: CGPoint!, locations: [NSNumber]!) {
        self.gradientLayer?.colors = colors
        self.gradientLayer?.locations = locations
        self.gradientLayer?.startPoint = startPoint
        self.gradientLayer?.endPoint = endPoint

        let centerPoint0 = CGPoint.init(x: startPoint.x * self.frame.width, y: startPoint.y * self.frame.height)
        let centerPoint1 = CGPoint.init(x: endPoint.x * self.frame.width, y: endPoint.y * self.frame.height)
        self.colorPoint0?.center = centerPoint0
        self.colorPoint1?.center = centerPoint1
    }

    private func updateLayer() {
        guard let centerColorPoint0 = self.colorPoint0?.center,
              let centerColorPoint1 = self.colorPoint1?.center else {
            return
        }

        let startPoint = CGPoint.init(x: centerColorPoint0.x / self.frame.width, y: centerColorPoint0.y / self.frame.height)
        let endPoint = CGPoint.init(x: centerColorPoint1.x / self.frame.width, y: centerColorPoint1.y / self.frame.height)
        self.gradientLayer?.startPoint = startPoint
        self.gradientLayer?.endPoint = endPoint

        if (self.selectAction != nil) {
            guard let selectAction = self.selectAction else {
                return
            }
            guard let cgColors = self.gradientLayer?.colors as? [CGColor],
                  let startPoint = self.gradientLayer?.startPoint,
                  let endPoint = self.gradientLayer?.endPoint,
                  let locations = self.gradientLayer?.locations as? [NSNumber]
            else {
                return
            }
            selectAction(cgColors, startPoint, endPoint, locations)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let p = touches.first?.location(in: self) else {
            return
        }
        guard let centerColorPoint0 = self.colorPoint0?.center,
            let centerColorPoint1 = self.colorPoint1?.center else {
            return
        }
        if (EditBackgroundColorCurrentColorView.pointDistance(point: p, toPoint: centerColorPoint1) < 40) {
            self.currentStatus = .moveColorPoint1
            return
        }
        if (EditBackgroundColorCurrentColorView.pointDistance(point: p, toPoint: centerColorPoint0) < 40) {
            self.currentStatus = .moveColorPoint0
            return
        }

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if self.currentStatus == .none {
            return
        }
        guard let p = touches.first?.location(in: self) else {
            return
        }
        if (p.x < 0 || p.y < 0 || p.x > self.frame.width || p.y > self.frame.height) {
            return
        }
        if self.currentStatus == .moveColorPoint1 {
            self.colorPoint1?.center = p
            return
        }
        if self.currentStatus == .moveColorPoint0 {
            self.colorPoint0?.center = p
            return
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.currentStatus = .none
        self.updateLayer()
    }

    class func pointDistance(point: CGPoint, toPoint: CGPoint) -> CGFloat {
        let distanceX = point.x - toPoint.x
        let distanceY = point.y - toPoint.y
        let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
        return distance
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}