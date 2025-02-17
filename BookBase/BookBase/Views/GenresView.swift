//
//  GenresView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/21/24.
//

import SwiftUI
import SwiftData

struct GenresView: View {
    @EnvironmentObject var manager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Spacer()
                Button{
                    manager.subjectSearch(subject: "fiction", lists: lists)
                }label:{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.placeholder)
                        .overlay{
                            Text("Fiction")
                        }
                        .frame(width: 125)
                }
                Spacer()
                Button{
                    manager.subjectSearch(subject: "science", lists: lists)
                }label:{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.placeholder)
                        .overlay{
                            Text("Science")
                        }
                        .frame(width: 125)
                }
                Spacer()
            }
            .frame(height: 125)
            HStack{
                Spacer()
                Button{
                    manager.subjectSearch(subject: "Business", lists: lists)
                }label:{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.placeholder)
                        .overlay{
                            Text("Business")
                        }
                        .frame(width: 125)
                }
                Spacer()
                Button{
                    manager.subjectSearch(subject: "fantasy", lists: lists)
                }label:{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.placeholder)
                        .overlay{
                            Text("Fantasy")
                        }
                        .frame(width: 125)
                }
                Spacer()
            }
            .frame(height: 125)
            HStack{
                Spacer()
                Button{
                    manager.subjectSearch(subject: "romance", lists: lists)
                }label:{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.placeholder)
                        .overlay{
                            Text("Romance")
                        }
                        .frame(width: 125)
                }
                Spacer()
                Button{
                    manager.subjectSearch(subject: "history", lists: lists)
                }label:{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.placeholder)
                        .overlay{
                            Text("History")
                        }
                        .frame(width: 125)
                }
                Spacer()
            }
            .frame(height: 125)
        }
    }
}

#Preview {
    GenresView()
        .environmentObject(BooksManager())
}
