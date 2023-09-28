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
            .padding(16)
            .background(.gray)
            .cornerRadius(12)
            .shadow(radius: 2)
            Spacer()
        }
        .background(.white)
        .asBottomSheetUI(show: $showDialog, content: BottomSheetContentExThree)
    }
    
    @ViewBuilder
    private func BottomSheetContentExOne() -> some View {
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
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 5)
    }
    
    @ViewBuilder
    private func BottomSheetContentExTwo() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Bottom Sheet title").foregroundColor(.white).font(.system(size: 18, weight: Font.Weight.semibold))
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.white)
                    .onTapGesture {
                        showDialog = false
                    }
            }
            Spacer().frame(height: 0)
            ForEach(0 ..< 6) { index in
                HStack(spacing: 10) {
                    Image(systemName: "list.bullet.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .onTapGesture {
                            showDialog = false
                        }
                    Text("Menu item \(index + 1)").foregroundColor(.white)
                    Spacer()
                }
            }
            Spacer().frame(height: 0)
        }
        .padding(20)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .shadow(radius: 5)
    }
    
    @ViewBuilder
    private func BottomSheetContentExThree() -> some View {
        VStack(alignment: .center, spacing: 40) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Bottom Sheet title").foregroundColor(.white).font(.system(size: 18, weight: Font.Weight.semibold))
                Spacer().frame(height: 0)
                ForEach(0 ..< 6) { index in
                    HStack(spacing: 10) {
                        Image(systemName: "list.bullet.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .onTapGesture {
                                showDialog = false
                            }
                        Text("Menu item \(index + 1)").foregroundColor(.white)
                        Spacer()
                    }
                }
                Spacer().frame(height: 0)
            }
            .padding(20)
            .background(.purple)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
            .shadow(radius: 5)
            
            Button {
                self.showDialog = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                    .onTapGesture {
                        showDialog = false
                    }
            }
            .padding(16)
            .background(.purple)
            .clipShape(Circle())
            .padding(.bottom, 40)
            .shadow(radius: 2)
        }
    }
}
