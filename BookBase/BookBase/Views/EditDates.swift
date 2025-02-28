//
//  EditDates.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/20/24.
//

import SwiftUI
import SwiftData

struct EditDates: View {
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @Binding var book : UserBook
    @State private var showAddSheet = false
    @State private var dates = TimeRead.mainDefault
    @State private var added = false
    @State private var edited = false
    @State private var wantToEdit = false
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea()
            VStack{
                SheetCapsule()
                    .offset(y: 5)
                HStack(spacing: 40){
                    Text("Reading Dates")
                        .bold()
                        .font(.system(size: 40))
                    Button{
                        showAddSheet.toggle()
                    }label:{
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                    }
                }
                .foregroundStyle(Color("DarkPurple"))
                List{
                    ForEach(book.userInfo.dates){ date in
                        VStack{
                            HStack{
                                Text("Start Date")
                                Text(formattedDate(date: date.startDate))
                            }
                            HStack{
                                Text("End Date")
                                Text(formattedDate(date: date.endDate))
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true){
                            Button{
                                dates = date
                                wantToEdit.toggle()
                                showAddSheet.toggle()
                            }label:{
                                Text("Edit")
                            }
                            .tint(.yellow)
                        }
                    }
                    .onDelete(perform: deleteDates)
                    .listRowBackground(Color.clear)
                    .foregroundStyle(Color("DarkPurple"))
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        }
        .foregroundStyle(Color("Text"))
        .sheet(isPresented: $showAddSheet, content: {
            AddDates(dates: $dates, showSheet: $showAddSheet, added: $added, edited: $edited, edit: $wantToEdit)
                .presentationDetents([.fraction(0.3)])
                .onDisappear{
                    wantToEdit = false
                    dates = TimeRead.mainDefault
                }
        })
        .onChange(of: added){
            if(added){
                addDates()
                added.toggle()
            }
        }
        .onChange(of: edited){
            if(edited){
                editDates()
                edited.toggle()
            }
        }
    }
    
    func addDates(){
        book.userInfo.dates.append(dates)
        for list in lists{
            if(list.books.contains(where: {$0.book.isbn == book.book.isbn})){
                list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
                list.books.append(book)
                try? context.save()
            }
        }
        dates = TimeRead.mainDefault
    }
    
    func deleteDates(at offsets: IndexSet){
        book.userInfo.dates.remove(atOffsets: offsets)
        for list in lists{
            if(list.books.contains(where: {$0.book.isbn == book.book.isbn})){
                list.books.removeAll(where: {$0.book.isbn == book.book.isbn})
                list.books.append(book)
                try? context.save()
            }
        }
    }
    
    func editDates(){
        book.userInfo.dates.removeAll(where: {$0.id == dates.id})
        addDates()
    }
    
    func formattedDate(date: Date?) -> String{
        if(date == nil){
            return "Not Finished"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date!)
    }
}

#Preview {
    EditDates(book: .constant(UserBook.mainDefault))
}
