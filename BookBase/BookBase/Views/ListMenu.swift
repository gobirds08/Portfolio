//
//  ListMenu.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/21/24.
//

import SwiftUI
import SwiftData

struct ListMenu: View {
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var showEditListSheet : Bool
    @Binding var editing : Bool
    @Binding var listToEdit : String
    var list : BookList
    var body: some View {
        Menu {
            Button(role: .destructive, action: {deleteList()}){
                Label("Delete", systemImage: "trash")
            }
            Button{
                listToEdit = list.name
                showEditListSheet.toggle()
                editing.toggle()
            }label:{
                Text("Rename")
            }
        }label:{
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
        }
        
    }
    
    func deleteList(){
        context.delete(list)
    }
}
