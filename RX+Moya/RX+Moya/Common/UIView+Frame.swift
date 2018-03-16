//
//  UIView+Frame.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            self.frame.origin.x = CGFloat(newValue)
        }
    }
    
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            self.frame.origin.y = CGFloat(newValue)
        }
    }
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(newValue) {
            self.frame.origin.x = CGFloat(newValue) - self.frame.size.width
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newValue) {
            self.frame.origin.y = CGFloat(newValue) - self.frame.size.height
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size.width = CGFloat(newValue)
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size.height = CGFloat(newValue)
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newValue) {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newValue) {
            self.frame.origin = newValue
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            self.frame.size = newValue
        }
    }
}
