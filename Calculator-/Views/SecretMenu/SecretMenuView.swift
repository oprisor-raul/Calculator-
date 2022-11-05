//
//  SecretMenuView.swift
//  Calculator-
//
//  Created by Oprișor Raul-Alexandru on 05.11.2022.
//

import SwiftUI
import LocalAuthentication

struct SecretMenuView: View {
    @State var authorized : Bool
    
    var body: some View {
        ZStack {
            if !(authorized) {
                Color.black
                MatrixRainView()
                    .ignoresSafeArea()
                Button("Escape the Matrix")
                {
                    authorization()
                }
                .fixedSize()
                .padding(30)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.gray).opacity(0.8)))
                .foregroundColor(.white)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform:
                    { if(authorized == false) {
                        self.authorization()}})
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
        SecretMenuView(authorized: false)
    }
}

