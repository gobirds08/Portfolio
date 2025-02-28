//
//  CreateListView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/12/24.
//

import SwiftUI
import SwiftData

struct CreateListView: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var showSheet : Bool
    @Binding var editing : Bool
    @Binding var listToEdit : String
    @State private var listName : String = ""
    @State private var isInvalid = false
    var body: some View {
        ZStack{
            LinearGradient.alternate
                .ignoresSafeArea()
            VStack(spacing: 0){
                SheetCapsule()
                    .offset(y: -30)
                HStack{
                    TextField("List Name", text: $listName)
                        .padding(8)
                        .background(.placeholder)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Button{
                        if(manager.validListName(lists: lists, name: listName)){
                            if(editing){
                                editList()
                                editing.toggle()
                            }else{
                                addList()
                            }
                            isInvalid = false
                            showSheet.toggle()
                        }else{
                            isInvalid = true
                        }
                    }label:{
                        Text("Submit")
                            .padding(8)
                            .background(.placeholder)
                            .clipShape(Capsule())
                    }
                }
                .foregroundStyle(Color("Text"))
                .padding()
                if(isInvalid){
                    Text("Invalid Name")
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    func addList(){
        context.insert(BookList(name: listName, books: []))
    }
    
    func editList(){
        var list = lists.first(where: {$0.name == listToEdit})
        list!.name = listName
        try? context.save()
    }
}
