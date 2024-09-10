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


class CodeHandler: ObservableObject {
    var code = [4, 8, 6, 2]
    @Published var numbers: [Int] = []
    func append(i: Int) {
        if numbers.count < 4 {
            numbers.append(i)
        }
    }
    var isOK: Bool {
        numbers == code
    }
    
    var timer: Timer?
    func clearInFewSeconds() {
        
    }
}

struct ResultView: View {
    var code_handler: CodeHandler
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var restant = 5
    
    var body: some View {
        VStack(spacing: 100) {
            Spacer()
            if code_handler.isOK {
                Text("Bravo ! 👏").font(.largeTitle)
                Spacer()
                Text("Tu as trouvé le code !").font(.title2)
            } else {
                Text("Dommage...").font(.largeTitle)
            }
            
            if !code_handler.isOK {
                Spacer()
                Text("\(code_handler.code.map(String.init).reduce("Le code était ", +))")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                .font(.title2).monospacedDigit()}
            
            VStack(){
                Text("Recommence dans \(restant) seconde\(restant > 1 ? "s":"") !")
                    .font(.headline)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                Text("Laisse aussi jouer tes copains !")
                    .font(.headline)
                    .padding(20)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(code_handler.isOK ? .green.opacity(0.8) : .red.opacity(0.6))
            .onReceive(timer) { _ in
                restant -= 1
                if restant < 1 {
                    code_handler.numbers.removeAll()
                }
            }
    }
}

struct PinEntryView: View {
    private let button_spacing = 20.0
    private let bullet_size = 20.0
    
    func press(_ i: Int) {
        code_handler.append(i: i)
    }
    
    @StateObject var code_handler: CodeHandler
    var body: some View {
        VStack() {
            Text("🔐").font(.largeTitle).padding()
            Text("Trouve le code").font(.title)
            HStack(spacing: 20) {
                if code_handler.numbers.count > 0 {
                    Circle()
                } else {
                    Circle().stroke(style: .init())
                }
                if code_handler.numbers.count > 1 {
                    Circle()
                } else {
                    Circle().stroke(style: .init())
                }
                if code_handler.numbers.count > 2 {
                    Circle()
                } else {
                    Circle().stroke(style: .init())
                }
                if code_handler.numbers.count > 3 {
                    Circle()
                } else {
                    Circle().stroke(style: .init())
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView: View {
    private var timer: Timer?
    @StateObject var code_handler = CodeHandler()
    var body: some View {
        if code_handler.numbers.count == 4 {
            ResultView(code_handler: code_handler)
        } else {
            PinEntryView(code_handler: code_handler).onAppear() {
                UIScreen.main.brightness = 1.0
            }
        }
    }
}

#Preview {
    ContentView()
}
