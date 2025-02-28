//
//  AddNoteView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/18/24.
//

import SwiftUI


struct AddNoteView: View {
    @Binding var note : String
    @Binding var showSheet : Bool
    @Binding var editLists : Bool
    var body: some View {
        GeometryReader{  proxy in
            let height = proxy.size.height
            ZStack{
                LinearGradient.main
                    .ignoresSafeArea()
                VStack{
                    SheetCapsule()
                        .offset(y: -20)
                    HStack{
                        TextField("", text: $note)
                            .padding(8)
                            .background(.placeholder)
                            .border(.placeholder)
                            .foregroundStyle(Color.white)
                            .frame(width: 200)
                        Button{
                            editLists.toggle()
                            showSheet.toggle()
                        }label:{
                            Text("Submit")
                                .padding(8)
                                .background(.placeholder)
                                .clipShape(Capsule())
                        }
                    }
                    .frame(height: height / 1.5)
                    .foregroundStyle(Color("Text"))
                }
            }
        }
    }
}

#Preview {
    AddNoteView(note: .constant(""), showSheet: .constant(false), editLists: .constant(false))
}
