//
//  SecretMenuView.swift
//  Calculator-
//
//  Created by Oprișor Raul-Alexandru on 05.11.2022.
//

import SwiftUI
import LocalAuthentication

struct SecretMenuView: View {
    @State private var authorized = false
    
    var body: some View {
        VStack {
            if !(authorized) {
                Spacer()
                Button("Authenticate with Face ID")
                {
                    authorization()
                }
                .fixedSize()
                .padding(30)
                .background(RoundedRectangle(cornerRadius: 10).fill(.green))
                .foregroundColor(.white)
            }
        }
        .onAppear(perform: {self.authorization()})
        .background(.black)
        if authorized {
            Home()
                .buttonStyle(BorderlessButtonStyle())
                .textFieldStyle(PlainTextFieldStyle())
        }
    }
    
    func authorization() {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authorize with Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        // Failed
                        authorized = false
                        return
                    }
                    // Success
                    authorized = true
                }
            }
        }
    }
}

struct SecretMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SecretMenuView()
    }
}
