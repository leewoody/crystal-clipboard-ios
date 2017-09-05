//
//  UIView+Extensions.swift
//  CrystalClipboard
//
//  Created by Justin Mazzocchi on 8/31/17.
//  Copyright © 2017 Justin Mazzocchi. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib(inBundle: Bundle? = nil, named: String? = nil, owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> Self? {
        return fromNibTypeInferring(inBundle: inBundle, named: named, owner: owner, options: options)
    }
    
    private class func fromNibTypeInferring<T>(inBundle: Bundle?, named: String?, owner: Any?, options: [AnyHashable: Any]?) -> T? {
        return (inBundle ?? Bundle.main).loadNibNamed(named ?? String(describing: self), owner: owner, options: options)?.first as? T
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}