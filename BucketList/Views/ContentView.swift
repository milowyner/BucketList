//
//  ContentView.swift
//  BucketList
//
//  Created by Milo Wyner on 9/6/21.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var showingError = false
    
    var body: some View {
        Group {
            if isUnlocked {
                AddPlacesView()
            } else {
                Button("Unlock Places") {
                    authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $showingError, content: {
            Alert(title: Text("Face ID or Touch ID Required"), message: Text("Please enable Face ID or Touch ID and try again."))
        })
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        print("Authentication error:", authenticationError?.localizedDescription ?? "Unknown error")
                        showingError = true
                    }
                }
            }
        } else {
            print("Biometric evaluation error:", error?.localizedDescription ?? "Unknown error")
            showingError = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
