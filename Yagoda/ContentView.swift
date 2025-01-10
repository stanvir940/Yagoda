//
//  ContentView.swift
//  Yagoda
//
//  Created by Tanvir Ahmed on 3/1/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = false

        var body: some View {
            Group {
//                if isLoggedIn {
//                    MainView()
//                } else {
                    AuthenticationView()
                //}
            }
            .onAppear {
                isLoggedIn = false
                isLoggedIn = Auth.auth().currentUser != nil
            }
        }
}

struct MainView: View {
    var body: some View {
//        Text("Welcome to StayFinder!")
//            .font(.largeTitle)
//            .padding()
        NavigationStack{
            NavigationStack{
                VStack{
                    HomePage()
                }
            }
        }
    }
    
}
