//
//  Snapshot.swift
//  Cities
//
//  Created by Yasar on 07.02.2021.
//

import UIKit
extension UIView {
    var snapshot: UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext() }
        UIGraphicsEndImageContext()
        return image
    }
}
