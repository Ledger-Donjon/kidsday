//
//  ContentView.swift
//  KidsDay
//
//  Created by Michael MOUCHOUS on 09/09/2024.
//

import SwiftUI

struct Button2: View {
    var number: Int
    var text: String = ""
    var clicked: (() -> Void) = {
        print("PRESSED")
    }
    
    var body: some View {
        Button(action: clicked) {
            VStack {
                Text(String(number))
                    .font(.title)
                if text != "" {
                    Text(text)
                        .font(.caption2)
                }
            }
        }.buttonStyle(CustomButtonStyle())
    }
}

struct CustomButtonStyle: ButtonStyle {
    let button_size = 50.0
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: button_size, height: button_size)
            .padding()
            .background(Color.gray)
            .foregroundColor(Color.white)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .cornerRadius(button_size)
    }
}


class CodeHandler {
    var numbers: [Int] = []
    func append(i: Int) {
        if numbers.count < 4 {
            numbers.append(i)
            print(numbers)
        }
    }
    var isOK: Bool {
        numbers == [4, 6, 5, 2]
    }
}

struct ContentView: View {
    @State private var refreshView = false
    let button_spacing = 20.0
    let bullet_size = 20.0
    var code_handler = CodeHandler()
    func press(_ i: Int) {
        code_handler.append(i: i)
        refreshView.toggle()
    }
    func effacer() {
        code_handler.numbers.removeLast()
        refreshView.toggle()
    }
    var body: some View {
        if code_handler.numbers.count == 4 {
            VStack(spacing: 100) {
                Text(code_handler.isOK ? "BRAVO !" : "DOMMAGE !" ).font(.largeTitle)
                Button("Recommence !") {
                    code_handler.numbers.removeAll()
                    refreshView.toggle()
                }
                .font(.headline)
                .padding()
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(50)
            }
        } else {
            VStack() {
                Text("Saisissez le code").font(.title)
                HStack(spacing: 20) {
                    if code_handler.numbers.count > 0 {
                        Circle().frame(width: bullet_size)
                    } else {
                        Circle().stroke(style: StrokeStyle())
                    }
                    if code_handler.numbers.count > 1 {
                        Circle().frame(width: bullet_size)
                    } else {
                        Circle().stroke(style: StrokeStyle())
                    }
                    if code_handler.numbers.count > 2 {
                        Circle().frame(width: bullet_size)
                    } else {
                        Circle().stroke(style: StrokeStyle())
                    }
                    if code_handler.numbers.count > 3 {
                        Circle().frame(width: bullet_size)
                    } else {
                        Circle().stroke(style: StrokeStyle())
                    }
                }.frame(width: bullet_size*4+3*20, height: bullet_size)
                    .padding(.bottom, 40)
                    .padding(.top, 20)
                VStack(spacing: button_spacing) {
                    HStack(spacing: button_spacing) {
                        Button2(number: 1, text: " ") { press(1) }
                        Button2(number: 2, text: "A B C") { press(2) }
                        Button2(number: 3, text: "D E F") { press(3) }
                    }
                    HStack(spacing: button_spacing) {
                        Button2(number: 4, text: "G H I") { press(4) }
                        Button2(number: 5, text: "J K L") { press(5) }
                        Button2(number: 6, text: "M N O") { press(6) }
                    }
                    HStack(spacing: button_spacing) {
                        Button2(number: 7, text: "P Q R S") { press(7) }
                        Button2(number: 8, text: "T U V") { press(8) }
                        Button2(number: 9, text: "W X Y Z") { press(9) }
                    }
                    Button2(number: 0) { press(0) }
                }
                if code_handler.numbers.count > 0 {
                    Button("Effacer") { effacer() }.padding(.top, 100)
                } else {
                    Button(" ") { }.padding(.top, 100)
                }
            }
            .padding()
            .id(refreshView)
        }
    }
}

#Preview {
    ContentView()
}
