//
//  ContentView.swift
//  iOS Example
//
//  Created by Ayoub on 5/9/2023.
//

import Foundation
import SwiftUI
import BottomSheetUI



struct ContentView: View {
    
    @State private var showDialog = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Button {
                showDialog.toggle()
            } label: {
                Text("Show dialog").foregroundColor(.black)
            }
            Spacer()
        }
        .background(.white)
        .asBottomSheetUI(show: $showDialog) {
            Text("dialog conent")
        }
    }
}
