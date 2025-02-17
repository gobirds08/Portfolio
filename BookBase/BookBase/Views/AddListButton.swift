//
//  AddListButton.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/11/24.
//

import SwiftUI

struct AddListButton: View {
    @EnvironmentObject var manager : BooksManager
    @Binding var showSheet : Bool
    var body: some View {
        Button{
            showSheet.toggle()
        }label:{
            Text("Add List")
                .padding(8)
                .background(.placeholder)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    AddListButton(showSheet: .constant(false))
        .environmentObject(BooksManager())
}
