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
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Capsule().fill(.gray.opacity(0.5)).frame(width: 40, height: 3)
                        Text("Bottom Sheet title").foregroundColor(.black).font(.system(size: 18, weight: Font.Weight.semibold))
                    }.padding(.leading, 50)
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.black.opacity(0.6))
                        .padding(16)
                        .onTapGesture {
                            showDialog = false
                        }
                }
                ForEach(0 ..< 3) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sub title \(index + 1)").foregroundColor(.black.opacity(0.8)).padding(.leading, 20).font(.system(size: 16, weight: Font.Weight.medium))
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                Spacer().frame(width: 16)
                                ForEach(0..<6) { index in
                                    Rectangle().fill(.gray.opacity(0.2)).frame(width: 90, height: 90).cornerRadius(8)
                                }
                            }
                        }.frame(height: 90)
                    }
                }
                Spacer().frame(height: 50)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 5)
        }
    }
}
