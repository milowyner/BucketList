//
//  ContentView.swift
//  BucketList
//
//  Created by Milo Wyner on 9/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
