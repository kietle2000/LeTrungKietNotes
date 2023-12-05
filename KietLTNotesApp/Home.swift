//
//  Home.swift
//  KietLTNotesApp
//
//  Created by Lê Kiệt on 12/5/23.
//

import SwiftUI
import Firebase

struct Home : View {
    @ObservedObject var Notes = getNotes()
    @State var show = false
    @State var txt = ""
    @State var docID = ""
    @State var name = ""
    @State var remove = false
    @State var isShowAddName = false
    @State var selectedContactTab = "List User"
    var tabs = ["List User", "All List"]
    
    var body : some View{
        ZStack(alignment: .bottomTrailing) {
            content
            feature
        }
        .sheet(isPresented: self.$show) {
            EditView(name: self.$name, txt: self.$txt, docID: self.$docID, show: self.$show)
        }
        .animation(.default)
        .modalAddName(isShow: $isShowAddName, name: $name)
        .onLoad {
            isShowAddName = true
        }
    }
    
    /// Contact tab
    var contactTab: some View{
        VStack {
            TabAboveCustom(tabs: .constant(tabs),
                           selection: $selectedContactTab,
                           underlineColor: Color.green) { title, isSelected in
                HStack(spacing: 8){
                    Text(title)
                        .foregroundColor(isSelected ? Color.white : Color.black)
                        .lineLimit(1)
                        .padding(.horizontal , 16)
                        .padding(.vertical , 8)
                }.background(isSelected ? Color.blue : Color.gray)
                .cornerRadius(6)

            } callback: {
            }
        }
        .padding(.horizontal, 16)
    }
    
    var feature: some View{
        Button(action: {
            self.txt = ""
            self.docID = ""
            self.show.toggle()
            
        }) {
            
            Image(systemName: "plus").resizable().frame(width: 18, height: 18).foregroundColor(.white)
            
        }.padding()
        .background(Color.blue)
        .clipShape(Circle())
        .padding()
    }
    
    var content:some View{
        VStack(alignment: .leading,spacing: 8){
            
            HStack{
                
                Text("Notes").font(.title).foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    
                    self.remove.toggle()
                    
                }) {
                    
                    Image(systemName: self.remove ? "xmark.circle" : "trash").resizable().frame(width: 23, height: 23).foregroundColor(.white)
                }
                
            }.padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color.blue)
            
            contactTab
            
            if self.Notes.data.isEmpty{
                
                if self.Notes.noData{
                    
                    Spacer()
                    
                    Text("No Notes !!!")
                    
                    Spacer()
                }
                else{
                    
                    Spacer()
                    
                    //Data is Loading ....
                    
                    Indicator()
                    
                    Spacer()
                }
            }
            
            else{
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack() {
                        let filteredData = selectedContactTab == "List User" ?
                            self.Notes.data.filter { $0.name == self.name } :
                            self.Notes.data
                        
                        ForEach(filteredData) { i in
                            noteCell(for: i)
                        }
                    }
                }

            }
            
            
        }.edgesIgnoringSafeArea(.top)
    }
    
    func noteCell(for note: Note) -> some View {
            HStack(spacing: 15) {
                Button(action: {
                    self.docID = note.id
                    self.txt = note.note
                    self.show.toggle()
                }) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(note.date)
                        Text(note.name)
                        Text(note.note)
                        Divider()
                    }
                    .padding(10)
                    .foregroundColor(.black)
                }

                if self.remove {
                    removeNoteButton(for: note)
                }
            }
            .padding(.horizontal)
        }

    func removeNoteButton(for note: Note) -> some View {
            Button(action: {
                let db = Firestore.firestore()
                db.collection("notes").document(note.id).delete()
            }) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
            }
        }
}



class Host : UIHostingController<ContentView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}

struct EditView : View {
    @Binding var name : String
    @Binding var txt : String
    @Binding var docID : String
    @Binding var show : Bool
    
    var body : some View{
        
        ZStack(alignment: .bottomTrailing) {
            TextField("Type Something", text: self.$txt)
                .padding()
                .background(Color.black.opacity(0.05))
            
            Button(action: {
                self.show.toggle()
                self.SaveData()
                
            }) {
                
                Text("Save").padding(.vertical).padding(.horizontal,25).foregroundColor(.white)
                
            }.background(Color.red)
            .clipShape(Capsule())
            .padding()
            
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    
    func SaveData(){
        let db = Firestore.firestore()
        
        if self.docID != ""{
            db.collection("notes").document(self.docID).updateData([
                "notes": self.txt,
                "name": self.name
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated")
                }
            }
        }else{
            db.collection("notes").document().setData(["notes":self.txt,"name": self.name,"date":Date()]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
    }
}

struct Note : Identifiable {
    var id : String
    var note : String
    var date : String
    var name : String
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
}

