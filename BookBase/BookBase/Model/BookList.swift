//
//  BookList.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/9/24.
//

import Foundation
import SwiftData

@Model
public class BookList : Identifiable{
    @Attribute(.unique) var name : String
    var books : [UserBook]
    
    init(name: String, books: [UserBook]) {
        self.name = name
        self.books = books
    }
    
    static let read = BookList(name: "Read", books: [])
    static let wantToRead = BookList(name: "Want to Read", books: [])
    static let currently = BookList(name: "Currently Reading", books: [])
}
