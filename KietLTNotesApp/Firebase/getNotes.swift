//
//  getNotes.swift
//  KietLTNotesApp
//
//  Created by Lê Kiệt on 12/5/23.
//

import SwiftUI
import Firebase

class getNotes : ObservableObject{
    
    @Published var data = [Note]()
    @Published var noData = false
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("notes").order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.noData = true
                return
            }
            
            if (snap?.documentChanges.isEmpty)!{
                
                self.noData = true
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    
                    let notes = i.document.get("notes") as! String
                    
                    let date = i.document.get("date") as! Timestamp
                    
                    let name = i.document.get("name") as! String
                    
                    let format = DateFormatter()
                    
                    format.dateFormat = "dd-MM-YY hh:mm a"
                    
                    let dateString = format.string(from: date.dateValue())
                    
                    self.data.append(Note(id: id, note: notes, date: dateString, name: name))
                }
                
                if i.type == .modified{
                    
                    // when data is changed...
                    
                    let id = i.document.documentID
                       
                    let notes = i.document.get("notes") as! String
                    
                    let name = i.document.get("name") as! String
                    
                    for i in 0..<self.data.count{
                        
                        if self.data[i].id == id{
                            
                            self.data[i].note = notes
                            self.data[i].name = name
                        }
                    }
                }
                
                if i.type == .removed{
                    
                    // when data is removed...
                    
                    let id = i.document.documentID
                    
                    for i in 0..<self.data.count{
                        
                        if self.data[i].id == id{
                            
                            self.data.remove(at: i)
                            
                            if self.data.isEmpty{
                                
                                self.noData = true
                            }
                            
                            return
                        }
                    }
                }
            }
        }
    }
}

