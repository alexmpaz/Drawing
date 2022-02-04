//
//  ContentView.swift
//  Drawing
//
//  Created by Alex Paz on 29/01/2022.
//

import SwiftUI

struct ArrowUp: Shape {
 
//    var arrowBase: Int
//    var arrowHeight: Int
//    var stemSize: Int
    var headHeight = 0.5
    var shaftWidth = 0.5
//    var lineThickness = 5.0
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(headHeight, shaftWidth) }
        set {
            headHeight = newValue.first
            shaftWidth = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let height = rect.height * headHeight
        let thickness = rect.width * shaftWidth / 2  // draws half thickness to one side, half to the other
        
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: height))
        path.addLine(to: CGPoint(x: rect.midX + thickness, y: height))
        path.addLine(to: CGPoint(x: rect.midX + thickness, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - thickness, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - thickness, y: height))
        path.addLine(to: CGPoint(x: rect.minX, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    let steps = 100
    var amount = 0.0
    var startPoint: UnitPoint = .top
    var endPoint: UnitPoint = .bottom
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(gradient: Gradient(colors: [
                            color(for: value, brightness: 1),
                            color(for: value, brightness: 0.2)
                        ]),
                                       startPoint: startPoint,
                                       endPoint: endPoint)
                        , lineWidth: 3)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var headHeight = 0.5
    @State private var shaftWidth = 0.25
    @State private var colorCycle = 0.0
    private var startPoint: UnitPoint {
        UnitPoint(x: startX, y: startY)
    }
    private var endPoint: UnitPoint {
        UnitPoint(x: endX, y: endY)
    }
    @State private var startX = 0.5
    @State private var startY = 0.0
    @State private var endX = 0.5
    @State private var endY = 1.0

    
    var body: some View {
        VStack {
            ArrowUp(headHeight: headHeight, shaftWidth: shaftWidth)
                .fill(.green)
                .frame(width: 50, height: 100)
                .onTapGesture {
                    withAnimation {
                        headHeight = Double.random(in: 0.2...0.8)
                        shaftWidth = Double.random(in: 0.3...0.7)
                    }
                    
                }
        
//            Text("Line thickness")
//                .padding(.top)
//            Slider(value: $lineThickness, in: 1.0...15.0)
//                .padding(.horizontal)
            
            ColorCyclingRectangle(amount: colorCycle, startPoint: startPoint, endPoint: endPoint)
                .frame(width: 320, height: 250)
                .padding()
            Text("Color cycle")
            Slider(value: $colorCycle)
            Slider(value: $startX, in: 0.0...1.0)
            Slider(value: $startY, in: 0.0...1.0)
                
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
