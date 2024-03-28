//
//  LetterShapes.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/27/24.
//

import SwiftUI

struct LetterShapes: Shape {
    var sides : Int
    func path(in rect: CGRect) -> Path {

        var path = Path()
        let side = min(rect.size.width, rect.size.height)
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let radius : CGFloat = side / 2
        //angle for pentagon is 72 degrees or 2pi/5 radians
        //angle for hexagon is 60 or pi/3
        let pentAngle : CGFloat = 2 * CGFloat.pi / 5
        let hexAngle : CGFloat = CGFloat.pi / 3
        
        switch sides {
        case 5: //square or diamond when rotated
            path.move(to: CGPoint(x: center.x - side/2, y: center.y + side/2))
            path.addLine(to: CGPoint(x: center.x + side/2, y: center.y + side/2))
            path.addLine(to: CGPoint(x: center.x + side/2, y: center.y - side/2))
            path.addLine(to: CGPoint(x: center.x - side/2, y: center.y - side/2))
            path.closeSubpath()
            break
        case 6: //pentagon
            path.move(to: CGPoint(x: center.x + radius * cos(pentAngle), y: center.y + radius * sin(pentAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(2 * pentAngle), y: center.y + radius * sin(2 * pentAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(3 * pentAngle), y: center.y + radius * sin(3 * pentAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(4 * pentAngle), y: center.y + radius * sin(4 * pentAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(5 * pentAngle), y: center.y + radius * sin(5 * pentAngle)))
            path.closeSubpath()
            break
        case 7: //hexagon
            path.move(to: CGPoint(x: center.x + radius * cos(hexAngle), y: center.y + radius * sin(hexAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(2 * hexAngle), y: center.y + radius * sin(2 * hexAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(3 * hexAngle), y: center.y + radius * sin(3 * hexAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(4 * hexAngle), y: center.y + radius * sin(4 * hexAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(5 * hexAngle), y: center.y + radius * sin(5 * hexAngle)))
            path.addLine(to: CGPoint(x: center.x + radius * cos(6 * hexAngle), y: center.y + radius * sin(6 * hexAngle)))
            path.closeSubpath()
            break
        default:
            break
        }
        
        return path
    }

}

#Preview {
    LetterShapes(sides: 6)
        .padding()
}
