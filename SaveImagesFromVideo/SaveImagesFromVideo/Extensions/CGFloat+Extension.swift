//
//  CGFloat+Extension.swift
//  SaveImagesFromVideo
//
//  Created by Ahmed Abuelmagd on 22/11/2022.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
