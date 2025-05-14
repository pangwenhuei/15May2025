//
//  ContentView.swift
//  Elec_Test
//
//  Created by Jameel Shammr on 28/10/2022.
//

import SwiftUI

struct ContentView: View {
    @State var progress:Float = 0.5
    @State var text = "10"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            CircularProgressBar(progress: $progress, text: $text)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
