//
//  ContentView.swift
//  ViewAndModifiers
//
//  Created by Student2 on 11/02/2022.
//

import SwiftUI

// struct ContentView: View {
//     var body: some View {
//         Text("Hello, world!")
//             .frame(maxWidth: .infinity, maxHeight: .infinity)
//             .background(.red)
//     }
// }
//
// maxWidth i maxHeight dla infinity zajmuje tyle przestrzeni
// ile może, ale uwzględnia aby inne widoki dostały tyle
// miejsca ile potrzebują

//
// struct ContentView: View {
//     var body: some View {
//         Button("Hello, world!") {
//             print(type(of: self.body))
//         }
//         .background(.red)
//         .frame(width: 200, height: 200)
//     }
// }
//
// kolejność jest ważna, background a potem frame da nam spore pole
// z małym czerwonym prostkątem podczas gdy w odwrotnej kolejności
// uzyskamy pole całe pokolorowane na czerwono

//struct ContentView: View {
//    var body: some View {
//        Text("Hello, world!")
//            .padding()
//            .background(.red)
//            .padding()
//            .background(.blue)
//            .padding()
//            .background(.green)
//            .padding()
//            .background(.yellow)
//    }
//}

// kod powyżej da nam Hello worlda w kolejno kolorowych obramówkach


// struct ContentView: View {
//     var body: View {
//         Text("Hello World")
//     }
// }
//
// powyższy kod jest błędny gdyż Swift nie wie co jest konkretnie
// wewnątrz View, musi uzupełnić lukę
// z kolei kod poniżej jest poprawny gdyż podajemy konkretnie Text
//
// struct ContentView: View {
//     var body: Text {
//         Text("Hello World")
//     }
// }
//
// ZStack, VStack itp implementują tupleView
// wszystkie tupleView zawierają elementy od 2 do 10 elementów
// wynika to z tego że gdzieś trzeba było postawić granicę

// struct ContentView: View {
//     @State private var useRedText = false
//
//     var body: some View {
//         if useRedText {
//             Button("Hello World") {
//                 useRedText.toggle()
//             }
//             .foregroundColor(.red)
//         } else {
//             Button("Hello World") {
//                 useRedText.toggle()
//             }
//             .foregroundColor(.blue)
//         }
//     }
// }
//
// Kod powyżej i poniżej robią dokładnie to samo, jedyna różnica
// to że kod poniżej jest krótszy, ładniejszy (w mojej opinii)
// oraz bardziej efektywny
//
// struct ContentView: View {
//     @State private var useRedText = false
//
//     var body: some View {
//         Button("Hello World") {
//             useRedText.toggle()
//         }
//         .foregroundColor(useRedText ? .red : .blue)
//     }
// }

// W kodzie poniżej modyfikator .font(.title) jest nadpisywany
// dla Gryffindoru przez .font(.largeTitle) jednakże blur nie jest
// nadpisywany, a akumulowany. Modyfikatory zatem mają różne własności
// i najlepiej analizować je znając lub przeglądając dokumentację
//
// VStack {
//     Text("Gryffindor")
//         .font(.largeTitle)
//         .blur(radius: 0)
//     Text("Hufflepuff")
//     Text("Ravenclaw")
//     Text("Slytherin")
// }
// .font(.title)
// .blur(radius: 5)
//
//
// W kodzie poniżej można zauważyć że widoki tworzone tak jak zmienne
// można swobodnie używać w kodzie, co więcej można je zmieniać
// modyfikatorami
//
// struct ContentView: View {
//     let motto1 = Text("Draco dormiens")
//     let motto2 = Text("nunquam titillandus")
//
//     var spells: some View {
//         VStack {
//             Text("Lumos")
//             Text("Obliviate")
//         }
//     }
//
//     var body: some View {
//         VStack {
//             spells
//             motto1
//                 .foregroundColor(.red)
//             motto2
//                 .foregroundColor(.blue)
//         }
//     }
// }

// Co więcej możemy tworzyć struktury będące widokami działające
// wewnątrz przykładowo VStacka na których również możemy użyć
// modyfikatorów
//
// struct CapsuleText: View {
//     var text: String
//
//     var body: some View {
//         Text(text)
//             .font(.largeTitle)
//             .padding()
//             .foregroundColor(.white)
//             .background(.blue)
//             .clipShape(Capsule())
//     }
// }
//
// struct ContentView: View {
//     var body: some View {
//         VStack(spacing: 10) {
//             CapsuleText(text: "First")
//                 .foregroundColor(.white)
//             CapsuleText(text: "Second")
//                 .foregroundColor(.yellow)
//         }
//     }
// }

//
// Kod poniżej pokazuje tworzenie własnych modyfikatorów widoków
// oraz jego przykładowe użycia

// struct Title: ViewModifier {
//     func body(content: Content) -> some View {
//         content
//             .font(.largeTitle)
//             .foregroundColor(.white)
//             .padding()
//             .background(.blue)
//             .clipShape(RoundedRectangle(cornerRadius: 10))
//     }
// }
//
// extension View {
//     func titleStyle() -> some View {
//         modifier(Title())
//     }
// }
//
// struct Watermark: ViewModifier {
//     var text: String
//
//     func body(content: Content) -> some View {
//         ZStack(alignment: .bottomTrailing) {
//             content
//             Text(text)
//                 .font(.caption)
//                 .foregroundColor(.white)
//                 .padding(5)
//                 .background(.black)
//         }
//     }
// }
//
// extension View {
//     func watermarked(with text: String) -> some View {
//         modifier(Watermark(text: text))
//     }
// }
//
// struct ContentView: View {
//     var body: some View {
//         Text("Hello World!")
//             .titleStyle()
//     }
// }
//
//
// Można tworzyć również własne kontenery, w wypadku poniżej jest to
// po prostu VStack zawierający w sobie HStacki, które zawierają
// w sobie jakieś elementy

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
    VStack {
        ForEach(0..<rows, id: \.self) { row in
            HStack {
                ForEach(0..<columns, id: \.self) { column in
                    content(row, column)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            Text("R\(row) C\(col)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
