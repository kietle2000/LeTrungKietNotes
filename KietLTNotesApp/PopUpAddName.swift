//
//  PopUpAddName.swift
//  KietLTNotesApp
//
//  Created by Lê Kiệt on 12/5/23.
//

import SwiftUI

struct PopUpAddName: ViewModifier {
    @Binding var show: Bool
    @Binding var name : String
    @State var isShowNoti = true
//    var onShowAddContact: () -> Void
        
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                // PopUp background color
                ZStack {
                    Color.black.opacity(show ? 0.5 : 0).edgesIgnoringSafeArea(.all)
                    // PopUp Window
                    
                    VStack(spacing: 16) {
                        Text("Notification")
                            .padding(.top, 24)
                            .padding(.horizontal, 16)
                        
                        Text(isShowNoti ? "Enter your name here" : "Please enter a name")
                            .foregroundColor(isShowNoti ? .black : Color.red)
                            .padding(.bottom, -12)
                        
                        TextField("Type Something", text: self.$name)
                            .padding(.horizontal, 16)
                            .multilineTextAlignment(.center)
                            .background(Color.black.opacity(0.05))
                        
                        HStack(alignment: .center){
                            Button(action: {
                                if name != ""{
                                    show.toggle()
                                }else{
                                    isShowNoti = false
                                }
                            }, label: {
                                Text("OK")
                                    .frame(width: 120,height: 44)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .cornerRadius(6)
                            })
                            .buttonStyle(PlainButtonStyle())
                        } .padding(.bottom, 20)
                            .padding(.horizontal, 16)
                    }
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
