//
//  CameraView.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/3/24.
//

import SwiftUI
import SwiftData

struct CameraView: View {
    @EnvironmentObject var bookManager : BooksManager
    @Environment(\.modelContext) private var context
    @Query private var lists : [BookList]
    @StateObject private var manager = CameraManager()
    @StateObject private var recognizer = ISBNRecognizer()
    @State private var submitted : Bool = false
    @Binding var showCamera : Bool
    var body: some View {
        ZStack{
            CameraOutputView(frame: manager.frame)
                .frame(width: 400, height: 400)
                VStack{
                    HStack{
                        Spacer()
                        Button{
                            showCamera.toggle()
                        }label:{
                            Image(systemName: "x.circle")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        Text("Scan the ISBN on your book")
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        if(!manager.taken){
                            Button{
                                manager.takePicture()
                            }label:{
                                Circle()
                                    .stroke(Color.white, lineWidth: 5.0)
                                    .frame(width: 80)
                            }
                        }else{
                            Spacer()
                            Button{
                                recognizer.recognized = ""
                                manager.taken = false
                                manager.start()
                            }label: {
                                ZStack{
                                    Capsule()
                                        .fill(.white)
                                    Text("Retake")
                                        .foregroundStyle(.black)
                                }
                                .frame(width: 80, height: 40)
                            }
                            Spacer()
                            Button{
                                submitted = true
                                recognizer.image = manager.frame
                                recognizer.requestRecognition()
                                manager.taken = false
                                if(recognizer.recognized != ""){
                                    bookManager.isbnSearch(isbn: recognizer.recognized, lists: lists)
                                    showCamera = false
                                }
                                
                            }label:{
                                ZStack{
                                    Capsule()
                                        .fill(.blue)
                                    Text("Submit")
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 80, height: 40)
                            }
                            Spacer()
                        }
                    }
                }
        }
    }
}

