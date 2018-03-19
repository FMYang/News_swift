//
//  AppDelegate.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/1/7.
//  Copyright © 2018年 杨方明. All rights reserved.
//

//  目标：将网易新闻、今日头条、澎湃等主流新闻app合并在一个app是不是很酷😁

import UIKit
import WCDBSwift
import Kingfisher
import KingfisherWebP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        // 支持webp格式图片
        KingfisherManager.shared.defaultOptions = [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)]

        let vc = MainContainVC()
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        nav.navigationBar.setBackgroundImage(UIColor.createImageFromColor(color: UIColor(valueRGB: 0xd43d3c)), for: UIBarMetrics.default)
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        DBManager.share.createAllTable()
        print(dbPath)
        
//        Database.globalTrace(ofSQL: { (sql) in
//            print("SQL: \(sql)")
//        })

        self.window?.makeKeyAndVisible()
        return true
    }
}



