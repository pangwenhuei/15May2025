//
//  CGColor+Extensions.swift
//  Elec_Test
//
//  Created by TTHQ23-PANGWENHUEI on 14/05/2025.
//

import CoreGraphics

extension CGColor {
    static func cgColorWithHexadecimal(_ hexadecimal: UInt32) -> CGColor {
        let r = CGFloat((hexadecimal >> 16) & 0xFF) / 255.0
        let g = CGFloat((hexadecimal >> 8) & 0xFF) / 255.0
        let b = CGFloat(hexadecimal & 0xFF) / 255.0
        let a = CGFloat((hexadecimal >> 24) & 0xFF) / 255.0

        return CGColor(red: r, green: g, blue: b, alpha: a)
    }
}
