//
//  SmallWidget.swift
//  ProgressWidgetExtension
//
//  Created by Brendan Kenney on 4/26/24.
//

import SwiftUI

struct SmallWidget: View {
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
                        ZStack{
                            Text("\(String(list.books.last!.userInfo.percentage))%")
                                .font(.system(size: 14))
                                .bold()
                            Circle()
                                .stroke(Color.green.opacity(0.5), lineWidth: 10)
                            Circle()
                                .trim(from: 0, to: CGFloat(Double(list.books.last!.userInfo.percentage) / 100.0))
                                .stroke(Color.green, lineWidth: 10)
                                .rotationEffect(.degrees(-90))
                        }
                    }else{
                        Text("NA")
                    }
                }else{
                    Text("NA")
                }
            }
    }
}
