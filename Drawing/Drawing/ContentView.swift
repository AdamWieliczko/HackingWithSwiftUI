//
//  ContentView.swift
//  Drawing
//
//  Created by Student2 on 10/02/2022.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Flower: Shape {
    var petalOffSet = -20.0
    var petalWidth = 100.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffSet, y: 0, width: petalWidth, height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(gradient: Gradient(colors: [
                            color(for: value, brightness: 1),
                            color(for: value, brightness: 0.5),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
            }
        }
        .drawingGroup() //renderuje za pomoca Metala, renderuje wczesniej gradienty, ale nie warto naduzywac bo czasami moze zwolnic aplikacje
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Trapezoid: Shape {
    var insetAmount: Double
    
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b

        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }

        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount

        var path = Path()

        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

            x += rect.width / 2
            y += rect.height / 2

            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

struct ContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    @State private var colorCycle = 0.0
    
    //@State private var amount = 0.0
    @State private var insetAmount = 50.0
    
    @State private var rows = 4
    @State private var columns = 4
    
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
// rysowanie trojkata
//
//    var body: some View {
//        Path { path in
//            path.move(to: CGPoint(x: 200, y: 100))
//            path.addLine(to: CGPoint(x: 100, y: 300))
//            path.addLine(to: CGPoint(x: 300, y: 300))
//            path.addLine(to: CGPoint(x: 200, y: 100))
//            //path.closeSubpath()
//        }
//        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//    }

    
// rysowanie ze struktow trojkata lub czesci kola

//    var body: some View {
//        Triangle()
//            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//            .frame(width: 300, height: 300)
//        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
//            .stroke(.blue, lineWidth: 10)
//            .frame(width: 300, height: 300)
//    }
    
// rysowanie przycietej czesci kola i modyfikacja Arca
//
//    var body: some View {
//        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
//            .strokeBorder(.blue, lineWidth: 40)
//    }
    
// rysowanie ksztaltu o wzorze kwiatu
////
//    var body: some View {
//        VStack {
//            Flower(petalOffSet: petalOffset, petalWidth: petalWidth)
//                //.stroke(.red, lineWidth: 1)
//                .fill(.red, style: FillStyle(eoFill: true))
//            Text("Offset")
//            Slider(value: $petalOffset, in: -40...40)
//                .padding([.horizontal, .bottom])
//
//            Text("Width")
//            Slider(value: $petalWidth, in: 0...100)
//                .padding(.horizontal)
//        }
//    }
    
// ksztalt stworzony ze zdjecia, w moim wypadku akurat pierwszego znalezionego
// zdjecia Krakowa
//
//    var body: some View {
//        Capsule()
//            .strokeBorder(ImagePaint(image: Image("Krakow"), sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.3), lineWidth: 20)
//            .frame(width: 300, height: 200)
//    }
    
// wyswietla ColorCyclingCircle wyswietlajace gradient kolorow oraz ich zmiane
// poprzez przesuniecie suwaka pod nim
//
//    var body: some View {
//        VStack {
//            ColorCyclingCircle(amount: colorCycle)
//                .frame(width: 300, height: 300)
//
//            Slider(value: $colorCycle)
//        }
//    }

// mozna laczyc kolorystycznie obrazy albo modyfikowac obrazy aby
// mnozyly kolory i nadawaly swego rodzaju filtr (nie dziala dla czarnych pikseli)
//
//    var body: some View {
//        ZStack {
//            Image("Krakow")
//                .colorMultiply(.red)
//        }
//    }
    
// nakladanie efektu bluru na zdjecie ktory mozna dowolnie modyfikowac
// suwakiem dostepnym pod zdjeciem
//
//    var body: some View {
//        VStack {
//            Image("Krakow")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .saturation(amount)
//                .blur(radius: (1 - amount) * 20)
//
//            Slider(value: $amount)
//                .padding()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.black)
//        .ignoresSafeArea()
//    }
    
    
// Tworzenie ksztaltu trapezoidu ktory po gescie tapniecia modyfikuje
// swoja gorna sciane przechodzac jednoczesnie animacja
//
//    var body: some View {
//        Trapezoid(insetAmount: insetAmount)
//            .frame(width: 200, height: 100)
//            .onTapGesture {
//                withAnimation {
//                    insetAmount = Double.random(in: 10...90)
//                }
//            }
//    }
    
// tworzenie szachownicy z jednorazowym, niejako animowanym przejsciem
//
//    var body: some View {
//        Checkerboard(rows: rows, columns: columns)
//            .onTapGesture {
//                withAnimation(.linear(duration: 3)) {
//                    rows = 8
//                    columns = 16
//                }
//            }
//    }
    
// skomplikowany algorytm tworzenia spirografu, ktory mimo wszystko jest
// ulepszona wersja jednego z poprzednich zadan
//
//    var body: some View {
//            VStack(spacing: 0) {
//                Spacer()
//
//                Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
//                    .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
//                    .frame(width: 300, height: 300)
//
//                Spacer()
//
//                Group {
//                    Text("Inner radius: \(Int(innerRadius))")
//                    Slider(value: $innerRadius, in: 10...150, step: 1)
//                        .padding([.horizontal, .bottom])
//
//                    Text("Outer radius: \(Int(outerRadius))")
//                    Slider(value: $outerRadius, in: 10...150, step: 1)
//                        .padding([.horizontal, .bottom])
//
//                    Text("Distance: \(Int(distance))")
//                    Slider(value: $distance, in: 1...150, step: 1)
//                        .padding([.horizontal, .bottom])
//
//                    Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
//                    Slider(value: $amount)
//                        .padding([.horizontal, .bottom])
//
//                    Text("Color")
//                    Slider(value: $hue)
//                        .padding(.horizontal)
//                }
//            }
//        }
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 300))
            path.addLine(to: CGPoint(x: 180, y: 280))
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
