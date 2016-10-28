//
//  DisplayAudioFile.swift
//  PlayAudioFIle
//
//  Created by michal on 27/10/16.
//  Copyright © 2016 Michal Bojanowicz. All rights reserved.
//

import UIKit

class DisplayAudioFile: UIView {
    
    
    var lines: [Float] = []
    
    override func draw(_ rect: CGRect) {
        let middleLine = makeMiddleLine(width: self.frame.width, height: self.frame.height)
        
        drawVerticalLines(array: lines)
        UIColor.green.setStroke()
        middleLine.stroke()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    
    func makeMiddleLine(width: CGFloat, height: CGFloat) ->UIBezierPath {
        let y = height / 2.0
        let line = UIBezierPath()
        line.move(to: CGPoint(x:0, y:y))
        line.addLine(to: CGPoint(x: width - 1.0,y: y))
        line.lineWidth = 1.0
        
        return line
    }
    
    
    func makeVerticalLine(x: CGFloat, yFrom: CGFloat, yTo: CGFloat) ->UIBezierPath {
        let line = UIBezierPath()
        line.move(to: CGPoint(x: x, y: yFrom))
        line.addLine(to: CGPoint(x: x, y: yTo))
        line.lineWidth = 1.0
        
        return line
    }
    
    func makeVerticalLines(values: [Float]) ->[UIBezierPath] {
        var vertLinesArray: [UIBezierPath] = []
        let currentWidth = self.frame.width
        let currentHeight = self.frame.height
        let stride = currentWidth / CGFloat(values.count)
        let scale = currentHeight
        
        for i in 0..<values.count {
            let y1 = CGFloat(0.5 - values[i] * 0.5)
            let y2 = 1 - y1
            let currentLine = makeVerticalLine(x: CGFloat(i) * stride, yFrom: y1 * scale, yTo: y2 * scale)
            vertLinesArray.append(currentLine)
        }
        
        return vertLinesArray
    }
    
    func drawVerticalLines(array: [Float]) {
        let vertLines = makeVerticalLines(values: array)
        for vertLine in vertLines {
            UIColor.red.setStroke()
            vertLine.stroke()
        }
    }
    
}
