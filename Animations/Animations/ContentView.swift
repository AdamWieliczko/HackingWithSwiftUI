//
//  ContentView.swift
//  Animations
//
//  Created by Student2 on 10/02/2022.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading), identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

struct ContentView: View {
    @State private var animationAmount = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    let letters = Array("Hello, SwiftUI")
    @State private var isShowingRed = false
    
// fajny efekt pulsowania przycisku
//
//    var body: some View {
//        Button("Tap Me") {
//            //animationAmount += 1
//        }
//        .padding(50)
//        .background(.red)
//        .foregroundColor(.white)
//        .clipShape(Circle())
//        .overlay(
//            Circle()
//                .stroke(.red)
//                .scaleEffect(animationAmount)
//                .opacity(2 - animationAmount)
//                .animation(
//                    .easeInOut(duration: 1)
//                        .repeatForever(autoreverses: false),
//                    value: animationAmount
//                )
//        )
//        .onAppear {
//            animationAmount = 2
//        }
//    }
    
// przy uzyciu steppera mozna rowniez wywolac animacje
//
//    var body: some View {
//        print(animationAmount)
//
//        return VStack {
//            Stepper("Scale amount", value: $animationAmount.animation(
//                .easeInOut(duration: 1)
//                    .repeatCount(3, autoreverses: true)
//            ), in: 1...10)
//
//            Spacer()
//
//            Button("Tap Me") {
//                animationAmount += 1
//            }
//            .padding(50)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            .scaleEffect(animationAmount)
//        }
//    }
    
    
// obracanie sie przycisku
//
//    var body: some View {
//        Button("Tap Me") {
//            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
//                animationAmount += 360
//            }
//        }
//        .padding(50)
//        .background(.red)
//        .foregroundColor(.white)
//        .clipShape(Circle())
//        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.5, y: 1, z: 0.5))
//    }
    
// kolejnosc animacji ma znaczenie, bo wykonuja sie kolejno dla powyzszych
// parametrow (ale ponizej poprzednich animacji jesli jakies byly)
//
//    var body: some View {
//        Button("Tap Me") {
//            enabled.toggle()
//        }
//        .frame(width: 200, height: 200)
//        .background(enabled ? .blue: .red)
//        .animation(.default, value: enabled)
//        .foregroundColor(.white)
//        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
//        .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
//    }
    
// przesuwanie gestem prostokatu po ekranie z animowanym powrotem do punktu
// poczatkowego
//
//    var body: some View {
//        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
//            .frame(width: 300, height: 200)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .offset(dragAmount)
//            .gesture(DragGesture()
//                        .onChanged { dragAmount = $0.translation}
//                        .onEnded { _ in
//                            withAnimation { dragAmount = .zero }
//                        }
//            )
//    }
    
// bardzo fajny efekt podazania liter za soba podczas gestu przeciagania palcem
//
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        dragAmount = .zero
                        enabled.toggle()
                    }
        )
    }
    
// animowany kwadrat co pojawia sie i znika naprzemian po kliknieciu
//
//    var body: some View {
//        VStack {
//            Button("Tap Me") {
//                withAnimation {
//                    isShowingRed.toggle()
//                }
//            }
//
//            if isShowingRed {
//                Rectangle()
//                    .fill(.red)
//                    .frame(width: 200, height: 200)
//                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
//            }
//        }
//    }
    
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(.blue)
//                .frame(width: 200, height: 200)
//
//            if isShowingRed {
//                Rectangle()
//                    .fill(.red)
//                    .frame(width: 200, height: 200)
//                    .transition(.pivot)
//            }
//        }
//        .onTapGesture {
//            withAnimation {
//                isShowingRed.toggle()
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
