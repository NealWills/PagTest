//
//  AppDelegate.swift
//  PagLayerNameTest
//
//  Created by Neal on 2022/11/2.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateInitialViewController()
        self.window?.rootViewController = vc
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let fileName = String.init(format: "%.0f", NSDate.init().timeIntervalSince1970)
        let filePath = AppDelegate.rootDirPath() + "\(fileName)"
        do {
            try FileManager.default.copyItem(at: url, to: URL.init(fileURLWithPath: filePath))
            let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController else {
                return true
            }
            vc.file = filePath
            guard let navVC = self.window?.rootViewController as? UINavigationController else {
                return true
            }
            navVC.pushViewController(vc, animated: true)
        } catch let error {
            print(error)
        }
        
        
        return true
    }
    
    
    class func rootDirPath() -> String {
        let rootDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
        let path = "\(rootDir)" + "/PAGFile"
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        } catch let error {
            print(error)
        }
        return "\(rootDir)" + "/PAGFile/"
    }

}

