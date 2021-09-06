//
//  ContentView.swift
//  BucketList
//
//  Created by Milo Wyner on 9/6/21.
//

import SwiftUI

enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    @Binding var state: LoadingState
    
    var body: some View {
        Text("Loading...")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    state = .success
                }
            }
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct ContentView: View {
    @State private var loadingState = LoadingState.loading
    
    var body: some View {
        switch loadingState {
        case .loading: LoadingView(state: $loadingState)
        case .success: SuccessView()
        case .failed: FailedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

