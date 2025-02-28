//
//  MediumWidget.swift
//  ProgressWidgetExtension
//
//  Created by Brendan Kenney on 4/26/24.
//

import SwiftUI

struct MediumWidget: View {
    var entry : ProgressEntry
    
    var body: some View {
        let colors = [Color(red: 168 / 255, green: 224 / 255, blue: 255 / 255), Color(red: 57 / 255, green: 43 / 255, blue: 88 / 255)]
            VStack{
                if let list = entry.lists.first(where: {$0.name == "Currently Reading"}){
                    if(!list.books.isEmpty){
                        Text(list.books.last!.book.title)
                            .font(.title)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        GeometryReader{ proxy in
                            let width = proxy.size.width
                            ZStack{
                                Capsule()
                                    .fill(Color.green.opacity(0.5))
                                HStack{
                                    Capsule()
                                        .fill(Color.green)
                                        .frame(width: width * (Double(list.books.last!.userInfo.percentage) / 100))
                                    Spacer()
                                }
                            }
                            .frame(height: 30)
                        }
                        Text("\(String(list.books.last!.userInfo.percentage))%")
                            .font(.system(size: 20))
                            .bold()
                    }else{
                        Text("NA")
                    }
                }else{
                    Text("NA")
                }
            }
    }
}
