//
//  AppVersionUpdateAlertVC.swift
//  GAAppUpdate
//
//  Created by MaciOS on 2021/7/23.
//

import UIKit
import EZSwiftExtensions

class AppVersionUpdateAlertVC: UIViewController {

    @IBOutlet weak var sureBut: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var newVersionLab: UILabel!
    
    var responseDict: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        //let tempWidth = ez.screenWidth - 25*2 - 17*2
        //sureBut.addGradient(start_color: "#FF4032", end_color: "#F50E34", frame: CGRect(x: 0, y: 0, w: tempWidth, h: 46), cornerRadius: 23)
        setupUI()
    }
    
    func setupUI() {
        let tempVersion = responseDict?["version"] as? String ?? ""
        newVersionLab.text = "最新版本(V\(tempVersion))"
        let message = responseDict?["releaseNotes"] as? String ?? ""
        let alertContent = "\(message)"
        //contentTextView.text = alertContent
        
        // 通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        // 将行间距设置为28
        paraph.lineSpacing = 5
        // 样式属性集合
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.foregroundColor: UIColor(hexString: "#666666")!,
                          NSAttributedString.Key.paragraphStyle: paraph]
        contentTextView.attributedText = NSAttributedString(string: alertContent, attributes: attributes)
    }
    
    /// 确认
    @IBAction func confirmBtnClick(_ sender: Any) {
        let trackViewUrlString = responseDict?["trackViewUrl"] as? String
        guard let trackViewUrlStr = trackViewUrlString, let appStoreURL = URL(string: trackViewUrlStr) else {
            return
        }
        if UIApplication.shared.canOpenURL(appStoreURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(appStoreURL)
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    /// 删除
    @IBAction func tapCancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /// 稍后更新
    @IBAction func tapLaterAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
