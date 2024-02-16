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
        }
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
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
