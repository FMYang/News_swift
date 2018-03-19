//
//  UIColor+Extend.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/17.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(valueRGB: UInt) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    /// 根据一个颜色创建一个UIImage
    ///
    /// - Parameter color: 颜色
    /// - Returns: UIImaged?
    static func createImageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let theImage =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        if theImage != nil {
            return theImage!
        }
        return nil
    }
}
