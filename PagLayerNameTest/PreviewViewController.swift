//
//  PreviewViewController.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/2.
//

import UIKit
import libpag


class LayerModel {
    var type: Int
    var name: String
    var index: Int
    var title: String? {
        get {
            return "[type: \(type)]" + " " + "[name: \(name)]"
        }
    }

    init(type: Int, name: String, index: Int) {
        self.type = type
        self.name = name
        self.index = index
    }
}

class PreviewViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    var pagView: PAGView?

    var pagFile: PAGFile?

    var file: String?

    var list: [LayerModel] = []

    var currentSelectModel: LayerModel?

    var gradientLayer: CAGradientLayer?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Setting", style: .done, target: self, action: #selector(navSettingClickAction(_:)))

        let p = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let navHeight = p > 1.8 ? 88 : 64

        gradientLayer = CAGradientLayer.init()
        gradientLayer?.frame = CGRectMake(0, CGFloat(navHeight + 40), self.view.frame.width, 300);
        self.view.layer.addSublayer(gradientLayer!)
        gradientLayer?.colors = [
            UIColor.init(white: 0, alpha: 1).cgColor,
            UIColor.init(white: 1, alpha: 1).cgColor,
        ]
        gradientLayer?.locations = [0, 1]
        gradientLayer?.startPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer?.endPoint = CGPoint.init(x: 1, y: 0)

        pagView = PAGView.init(frame: CGRectMake(0, CGFloat(navHeight + 40), self.view.frame.width, 300))
        self.view.addSubview(pagView!)
        pagView?.setRepeatCount(0)
        pagView?.layer.borderColor = UIColor.init(red: 0.6, green: 0.8, blue: 0.7, alpha: 1).cgColor
        pagView?.layer.borderWidth = 1
        pagView?.layer.cornerRadius = 3

        pagView?.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(previewDetailClickAction(_:)))
        pagView?.addGestureRecognizer(tapGes)

        self.tableView.register(UINib.init(nibName: "NameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DefaultId")

        self.previewFile(file)
        // Do any additional setup after loading the view.
    }

    @objc func navSettingClickAction(_ sender: UIBarButtonItem) {
        weak var weakSelf = self
        let vc = UIAlertController.init(title: "Setting", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        vc.addAction(.init(title: "修改背景色", style: .default, handler: { _ in
            weakSelf?.settingBackColorAction()
        }))
        vc.addAction(.init(title: "取消", style: .cancel, handler: { _ in }))
        self.present(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.pagFile != nil) {
            self.pagView?.setComposition(self.pagFile)
        }
    }

    func settingBackColorAction() {
        guard let cgColors = self.gradientLayer?.colors as? [CGColor],
              let startPoint = self.gradientLayer?.startPoint,
              let endPoint = self.gradientLayer?.endPoint,
              let locations = self.gradientLayer?.locations as? [NSNumber]
        else {
            return
        }
        weak var weakSelf = self
        EditBackgroundColorPop.show(colors: cgColors,
                startPoint: startPoint,
                endPoint: endPoint,
                locations: locations
        ) { colors, startPoint, endPoint, locations in
            weakSelf?.gradientLayer?.colors = colors
            weakSelf?.gradientLayer?.startPoint = startPoint
            weakSelf?.gradientLayer?.endPoint = endPoint
            weakSelf?.gradientLayer?.locations = locations
        }
    }

    @objc func previewDetailClickAction(_ ges: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreviewDetailViewController") as? PreviewDetailViewController else {
            return
        }
        vc.filePath = self.file
        vc.pagFile = self.pagFile
        vc.gradientLayer = CAGradientLayer.init()
        vc.gradientLayer?.colors = self.gradientLayer?.colors
        vc.gradientLayer?.locations = self.gradientLayer?.locations
        vc.gradientLayer?.startPoint = self.gradientLayer?.startPoint ?? CGPoint.init(x: 0, y: 0)
        vc.gradientLayer?.endPoint = self.gradientLayer?.endPoint ?? CGPoint.init(x: 1, y: 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func previewFile(_ file: String?) {

        let pathList = file?.components(separatedBy: "/")
        self.titleLabel.text = pathList?.last ?? ""

        pagFile = PAGFile.load(file)
        pagView?.setComposition(pagFile)
        pagView?.play()

        guard let count = pagFile?.numChildren() else {
            return
        }
        for i in 0..<count {
            let layer = pagFile?.getLayerAt(Int32(i))
            let layerType = layer?.layerType().rawValue ?? 0
            let layerName = layer?.layerName() ?? ""
            list.append(LayerModel.init(type: layerType, name: layerName, index: i))
        }
        self.tableView.reloadData()
    }

    func deleteLayer(indexPath: IndexPath) {
        let model = list[indexPath.row]
        if model.name.count > 0 {
            let layer = pagFile?.getLayersByName(model.name).first
            pagFile?.remove(layer)
        } else {
            let layer = pagFile?.getLayerAt(Int32(model.index))
            pagFile?.remove(layer)
        }
        list.remove(at: indexPath.row)
        pagView?.setComposition(pagFile)
        tableView.reloadData()
    }

    func editLayer(indexPath: IndexPath) {
        let model = list[indexPath.row]

        if model.type == 3 {
            self.editTextLayer(model: model)
        }
        if model.type == 5 {
            self.editImageLayer(model: model)
        }
        if model.type == 6 {
            self.editBMPLayer(model: model)
        }
    }

    func editTextLayer(model: LayerModel) {
        if let textLayer = pagFile?.getLayersByName(model.name).first as? PAGTextLayer {
//            weak var weakLayer = textLayer
            EditTextPopPop.showPop(withDomain: "") { newString, _ in
//                DispatchQueue.main.async {
                textLayer.setText(newString)
//                }
            }
            return
        }
        if let textLayer = pagFile?.getLayerAt(Int32(model.index)) as? PAGTextLayer {
//            weak var weakLayer = textLayer
            EditTextPopPop.showPop(withDomain: "") { newString, _ in
//                DispatchQueue.main.async {
                textLayer.setText(newString)
//                }
            }
            return
        }
        if let bmpLayer = pagFile?.getLayerAt(Int32(model.index)) as? PAGLayer {
            if bmpLayer.layerType() == PAGLayerType.preCompose {
                weak var weakSelf = self
                EditTextPopPop.showPop(withDomain: "") { newString, _ in
                    let text = PAGText.init()
                    text.text = newString
                    DispatchQueue.main.async {
                        weakSelf?.pagFile?.replaceText(Int32(model.index), data: text)
                    }
                }
                return
            }
        }

    }

    func editImageLayer(model: LayerModel) {
        self.currentSelectModel = model
        let pickerVC = UIImagePickerController.init()
        pickerVC.delegate = self
        self.navigationController?.present(pickerVC, animated: true)
    }

    func didSelectImage(_ image: UIImage) {

        guard let model = self.currentSelectModel else {
            return
        }
        if let imageLayer = pagFile?.getLayersByName(model.name).first as? PAGImageLayer {
            let pagImage = PAGImage.fromCGImage(image.cgImage)
            imageLayer.setImage(pagImage)
            return
        }
        if let imageLayer = pagFile?.getLayerAt(Int32(model.index)) as? PAGImageLayer {
            let pagImage = PAGImage.fromCGImage(image.cgImage)
            imageLayer.setImage(pagImage)
            return
        }
        if let bmpLayer = pagFile?.getLayerAt(Int32(model.index)) as? PAGLayer {
            if bmpLayer.layerType() == PAGLayerType.preCompose {
                let pagImage = PAGImage.fromCGImage(image.cgImage)
                self.pagFile?.replaceImage(Int32(model.index), data: pagImage)
                return
            }

        }
    }

    func editBMPLayer(model: LayerModel) {
        weak var weakSelf = self
        let vc = UIAlertController.init(title: "特殊替换", message: "BMP图层具有不确定性，替换可能失败", preferredStyle: UIAlertController.Style.actionSheet)
        vc.addAction(.init(title: "特殊替换图片", style: .default, handler: { _ in
            weakSelf?.editImageLayer(model: model)
        }))
        vc.addAction(.init(title: "特殊替换文字(暂未启用)", style: .default, handler: { _ in
//            weakSelf?.editImageLayer(model: model)
            weakSelf?.editTextLayer(model: model)
        }))
        vc.addAction(.init(title: "取消", style: .cancel, handler: { _ in }))
        self.present(vc, animated: true)
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
        cell?.title = "\([indexPath.row])" + " " + (list[indexPath.row].title ?? "")
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = list[indexPath.row]
        var tag = ""
        if model.type == 3 {
            tag = "文字"
        } else if model.type == 5 {
            tag = "图片"
        }
        weak var weakSelf = self
        let vc = UIAlertController.init(title: list[indexPath.row].title, message: nil, preferredStyle: UIAlertController.Style.alert)
        vc.addAction(.init(title: "修改\(tag)图层", style: .default, handler: { _ in
            weakSelf?.editLayer(indexPath: indexPath)
        }))
        vc.addAction(.init(title: "删除图层", style: .default, handler: { _ in
            weakSelf?.deleteLayer(indexPath: indexPath)
        }))

        vc.addAction(.init(title: "知道了", style: .cancel, handler: { _ in }))
        self.present(vc, animated: true)

    }


}

extension PreviewViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.didSelectImage(image)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
