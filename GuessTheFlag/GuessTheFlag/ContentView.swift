//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Student2 on 09/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var buttonTitle = "Continue"
    
    @State private var score = 0
    
    @State private var whatRound = 1
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        FlagImage(number: number)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(buttonTitle, action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        if(whatRound == 8) {
            reset()
        }
        whatRound += 1
    }
    
    func reset() {
        score = 0
        whatRound = 1
        buttonTitle = "Continue"
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
        }
        
        if whatRound == 8 {
            scoreTitle += ", that was the last round"
            buttonTitle = "Reset"
        }

        showingScore = true
    }
    
    func FlagImage(number: Int) -> some View {
        Button {
            withAnimation() {
                flagTapped(number)
            }
        } label: {
            Image(countries[number])
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
                .rotation3DEffect(.degrees(360), axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
