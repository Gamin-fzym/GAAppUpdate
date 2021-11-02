//
//  AboutUSVC.swift
//  GAAppUpdate
//
//  Created by MaciOS on 2021/7/23.
//

import UIKit
import Toast_Swift

class AboutUSVC: UIViewController {

    @IBOutlet weak var ver_view: UIView!
    @IBOutlet weak var lb_version: UILabel!
    @IBOutlet weak var v_update: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let infoDictionary = Bundle.main.infoDictionary!
        let minorVersion = infoDictionary["CFBundleShortVersionString"]//版本号（内部标示）
        let appVersion = minorVersion as! String
        self.lb_version.text = "V\(appVersion)"
        self.ver_view.addTapGesture { (_) in
            let trackViewUrlStr = "https://itunes.apple.com/cn/app/id\(GlobalConst.RJAPPID)?mt=8"
            guard let appStoreURL = URL(string: trackViewUrlStr) else {
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
        }
        
        self.v_update.addTapGesture { [weak self](_) in
            self?.click_update()
        }
        judge_update()
    }

    func judge_update() {
        self.v_update.isHidden = true
        UpdateAPI.requestVersionAPI(GlobalConst.RJAPPID, greatThan: false) {

        } completion: {[weak self] (responseDict) in
            DispatchQueue.main.async {
                self?.v_update.isHidden = false
            }
        }
    }
    
    func click_update() {
        // 直接显示接口中的更新内容
        UpdateAPI.requestVersionAPI(GlobalConst.RJAPPID, greatThan: true) {[weak self] in
            self?.view.makeToast("已经是最新版本了~",duration: 2)
        } completion: { (responseDict) in
            // 自定义 view
            DispatchQueue.main.async {
                let alert = AppVersionUpdateAlertVC()
                alert.responseDict = responseDict
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .coverVertical
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
            }
        }
    }
}
