//
//  UserBook.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/9/24.
//

import Foundation

public struct UserBook : Codable, Identifiable{
    var userInfo : UserBookInfo
    var book : Book
    public var id = UUID()
    
    static let mainDefault = UserBook(userInfo: UserBookInfo.mainDefault, book: Book.mainDefault)
}
