//
//  UpdateAPI.swift
//  GAAppUpdate
//
//  Created by MaciOS on 2021/7/23.
//

import Foundation

struct UpdateAPI {
    /// 检查更新  greatThan true:线上版本大于本地版本 false:线上版本大于等于本地版本
    static func requestVersionAPI(_ appId: String, greatThan: Bool, notUpdate:(() -> ())? , completion: ((_ dict: [String: Any]) -> ())?) {
        let kItunesURL = "https://itunes.apple.com/cn/lookup?id=\(appId)"
        guard let url = URL(string: kItunesURL) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) {(responseData, response, error) in
            guard let data = responseData else {
                return
            }
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
                guard let resultsArray = dict["results"] else {
                    return
                }
                let results = resultsArray as! [[String: Any]]
                if results.count > 0 {
                    let responseDict = results.first ?? [:]
                    let currentBundleShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
                    let lastVersion = responseDict["version"] as? String ?? ""
                    /// to update
                    if (greatThan) {
                        // 线上版本号 比 本地版本号高
                        if currentBundleShortVersion.compare(lastVersion) == .orderedAscending {
                            completion?(responseDict)
                        } else {
                            notUpdate?()
                        }
                    } else {
                        // 线上版本号 大于等于 本地版本号
                        if currentBundleShortVersion.compare(lastVersion) != .orderedDescending {
                            completion?(responseDict)
                        } else {
                            notUpdate?()
                        }
                    }
                } else {
                    notUpdate?()
                }
            } catch {
                notUpdate?()
            }
        }
        dataTask.resume()
    }
}
