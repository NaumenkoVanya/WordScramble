//
//  ContentView.swift
//  WordScramble
//
//  Created by Ваня Науменко on 16.02.24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    // MARK: Управление оповещениями

    @State private var errorTittle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

//    let peopel = ["Ivan", "Vova", "Sasha", "Zheny", "Maksim"]
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTittle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: Проверка:  использовалось ли слово ранее или нет.

    func isOroginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    // MARK: На реальность существования слова

    func isPossibole(word: String) -> Bool {
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

    // MARK: Проверка на ошибки в слове

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }

    // MARK: Устанавливает заголовок и меняет логическое значение

    func wordErroe(tittle: String, message: String) {
        errorTittle = tittle
        errorMessage = message
        showingError = true
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOroginal(word: answer) else {
            wordErroe(tittle: "Word used already", message: "De more priginal")
            return
        }
        
        guard isPossibole(word: answer) else {
            wordErroe(tittle: "Word not possible", message: "You can not spell that word form \(rootWord) !")
            return
        }
        
        guard isReal(word: answer) else {
            wordErroe(tittle: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }

    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkword"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
}

#Preview {
    ContentView()
}

//    func testBundle() {
//        if let fileURL = Bundle.main.url(forResource: "some-url", withExtension: "txt") {
//            if let feleContents = try? String(contentsOf: fileURL) {}
//        }
//    }

//    func testString() {
//        let word = "swift"
//        let checker = UITextChecker()
//        let range = NSRange(location: 0, length: word.utf16.count)
//        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//        let allGood = misspelledRange.location == NSNotFound
//    }

//            Text("Hello World")
//            Text("Hello World")
//            Text("Hello World")
//            Spacer()
//            ForEach(0..<5) {
//                Text("Dinamic row \($0)")
//            }
//            Spacer()
//            Section("section 1") {
//                Text("Static row 1")
//                Text("Static row 2")
//            }
//            Section("Sectipon 2") {
//                ForEach(0..<5) {
//                    Text("Dinavic row \($0)")
//                }
//            }
//            Section("Section 3") {
//                Text("Static row 3")
//                Text("Static row 4")
//            }
