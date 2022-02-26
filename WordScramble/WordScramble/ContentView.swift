//
//  ContentView.swift
//  WordScramble
//
//  Created by Student2 on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }

                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                
                
                Text("Your score is \(usedWords.count)")
                //po prostu kazde slowo to jeden punkt
                //jak dla mnie lepsze by bylo dac to do toolbara
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Restart Game") {
                        startGame()
                    }
                }
//                ToolbarItem(placement: .bottomBar) {
//                    Text("Your score is \(usedWords.count)")
//                }
            }
        }
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 3 else {
            wordError(title: "Word is too short", message: "I have to be at least 4 characters long")
            return
        }

        guard answer != rootWord else {
            wordError(title: "You can't put original word", message: "Write other ideas")
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        usedWords.insert(answer, at: 0)
        //powyżej konkretnie wstawiamy na miejsce zerowe zamiast np
        //appendować żebyśmy widzieli że rzeczywiście słowo zostało dodane
        newWord = ""
    }

    func startGame() {
        usedWords.removeAll()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")

                rootWord = allWords.randomElement() ?? "adamwieliczko"
                //w tutorialu jako słowo awaryjne dano silkworm, ale
                //ja zmienilem je na moje imie i nazwisko
                return
            }
        }

        fatalError("Could not load start.txt from bundle.")
    }

    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
