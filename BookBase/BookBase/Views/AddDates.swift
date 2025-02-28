//
//  AddDates.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/20/24.
//

import SwiftUI

struct AddDates: View {
    @Binding var dates : TimeRead
    @Binding var showSheet : Bool
    @Binding var added : Bool
    @Binding var edited : Bool
    @Binding var edit : Bool
    @State private var noEnd = false
    var body: some View {
        ZStack{
            LinearGradient.main
                .ignoresSafeArea()
            VStack{
                SheetCapsule()
                    .offset(y: -20)
                HStack(spacing: 60){
                    Spacer()
                    VStack(spacing: 20){
                        DatePicker("Start Date", selection: $dates.startDate, displayedComponents: [.date])
                        DatePicker("End Date", selection: Binding(get: {self.dates.endDate ?? Date()}, set: {self.dates.endDate = $0}), displayedComponents: [.date])
                        Button{
                            if(noEnd){
                                dates.endDate = nil
                                noEnd.toggle()
                            }
                            if(edit){
                                edited.toggle()
                                edit.toggle()
                            }else{
                                added.toggle()
                            }
                            showSheet.toggle()
                        }label:{
                            Text("Submit")
                                .padding(8)
                                .background(.placeholder)
                                .clipShape(Capsule())
                        }
                    }
                    VStack{
                        Text("NA")
                        Button{
                            noEnd.toggle()
                        }label:{
                            Image(systemName: noEnd ? "checkmark.square.fill" : "square")
                        }
                    }
                    Spacer()
                }
            }
        }
        .foregroundStyle(Color("DarkPurple"))
    }
}
