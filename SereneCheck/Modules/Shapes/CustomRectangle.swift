//
//  CustomRectangle.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import Foundation
import SwiftUI

struct CustomRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // Top-Left
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))// Top-Right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))// Bottom-Right
        
        let point1 = CGPoint(x: rect.midX + 50, y: rect.maxY + 20)
        let point2 = CGPoint(x: rect.midX - 50, y: rect.maxY + 20)
        
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY), // Bottom-Left
            control1: point1,
            control2: point2)
        
        path.closeSubpath()
        
        return path
    }
}
