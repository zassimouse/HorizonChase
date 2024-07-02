//
//  CGSize + Extensions.swift
//  HorizonChase
//
//  Created by Denis Haritonenko on 2.07.24.
//

import Foundation

extension CGSize {
    var minX: CGFloat {
        -width / 2
    }
    
    var maxY: CGFloat {
        height / 2
    }
    
    var minY: CGFloat {
        -height / 2
    }
}
