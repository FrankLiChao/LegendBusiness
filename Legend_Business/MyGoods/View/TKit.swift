//
//  TKit.swift
//  TKitDemoInSwift
//
//  Created by 王薰怡 on 16/9/29.
//  Copyright © 2016年 王薰怡. All rights reserved.
//

import UIKit

protocol TKColorable {
    var color: UIColor! { set get }
}

protocol TKStrokable {
    var lineWidth: CGFloat { set get }
}

extension TKStrokable {
    var lineWidth: CGFloat {
        return 1.0
    }
}