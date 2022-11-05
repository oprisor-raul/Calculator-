//
//  CalculatorView.swift
//  Calculator-
//
//  Created by Oprișor Raul-Alexandru on 04.11.2022.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case mutliply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct CalculatorView: View {
    
    @State var value = "0"
    @State var runningNumber = 0.0
    @State var currentOperation: Operation = .none
    @State var previousEqual: Bool = false
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        NavigationView(){
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    // Text display
                    HStack {
                        Spacer()
                        VStack{
                            if(value == "28980") {
                                // Secret Menu
                                NavigationLink(destination: SecretMenuView()) {
                                    Text("                                      ")
                                }
                                Spacer()
                            }
                            Text(value)
                                .bold()
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    // Our buttons
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    self.didTap(button: item)
                                }, label: {
                                    Text(item.rawValue)
                                        .font(.system(size: 32))
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: self.buttonHeight()
                                        )
                                        .background(item.buttonColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(self.buttonWidth(item: item)/2)
                                })
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
            }
        }
    }
    
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .mutliply, .divide, .decimal, .negative, .percent, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0
                self.previousEqual = false
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Double(self.value) ?? 0
                self.previousEqual = false
            }
            else if button == .mutliply {
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0
                self.previousEqual = false
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0
                self.previousEqual = false
            }
            else if button == .percent {
                let currentValue = Double(self.value) ?? 0
                self.value = "\(currentValue * 0.01)"
            }
            else if button == .negative {
                    let currentValue = Double(self.value) ?? 0
                    self.value = "\(-currentValue)"

            }
            else if button == .decimal {
                self.value.append(".")
            }
            
            else if button == .equal {
                let runningValue = self.runningNumber
                let currentValue = Double(self.value) ?? 0
                let previousCurrentValue = Double(self.value) ?? 0
                switch self.currentOperation {
                case .add:
                    self.value = "\((runningValue + currentValue).rounded(toPlaces: 9))"
                    if (!self.previousEqual) {
                        self.runningNumber = previousCurrentValue }
                    while ((self.value.count) > 10 || self.value.hasSuffix(".")){
                        self.value.removeLast(1)
                    }
                    previousEqual = true
                case .subtract:
                    if (!self.previousEqual) {
                        self.value = "\((runningValue - currentValue).rounded(toPlaces: 9))"
                        self.runningNumber = previousCurrentValue
                    }
                    else {
                        // Different order if the user taps equal multiple times:
                        self.value = "\((currentValue - runningValue).rounded(toPlaces: 9))"
                    }
                    while ((self.value.count) > 10 || self.value.hasSuffix(".")){
                        self.value.removeLast(1)
                    }
                    previousEqual = true
                case .multiply:
                    self.value = "\((runningValue * currentValue).rounded(toPlaces: 9))"
                    if (!self.previousEqual) {
                        self.runningNumber = previousCurrentValue
                    }
                    while ((self.value.count) > 10 || self.value.hasSuffix(".")){
                        self.value.removeLast(1)
                    }
                    previousEqual = true
                case .divide: do {
                    if currentValue == 0 {
                        // Division by zero
                        self.value = "Error"
                    }
                    else {
                        if (!self.previousEqual) {
                            self.value = "\((runningValue / currentValue).rounded(toPlaces: 9))"
                            self.runningNumber = previousCurrentValue
                            print(runningValue)
                            print(currentValue)
                            print(value)
                        }
                        else {
                            // Different order if the user taps equal multiple times:
                            self.value = "\((currentValue / runningValue).rounded(toPlaces: 9))"
                            print(currentValue)
                            print(runningValue)
                            print(value)
                        }
                    }
                    while ((self.value.count) > 10 || self.value.hasSuffix(".")){
                        self.value.removeLast(1)
                    }
                    previousEqual = true
                }
                case .none:
                    break
                }
            }
            if (self.value.hasSuffix(".0")) {
                self.value.removeLast(2)
            }
            if (button == .negative || button == .percent || button == .decimal) {
                // nothing happens, the number switches with a - in front
            } else if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
            self.runningNumber = 0
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else {
                if ((self.value).count < 11) {
                    self.value = "\(self.value)\(number)"}
            }
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
