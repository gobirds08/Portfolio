//
//  UserBookInfo.swift
//  BookBase
//
//  Created by Brendan Kenney on 4/4/24.
//

import Foundation

public struct UserBookInfo : Codable{
    var like : Bool
    var lists : [String]
    var notes : [String]
    var dates : [TimeRead]
    var percentage : Int
    
    static let mainDefault = UserBookInfo(like: false, lists: [], notes: [], dates: [], percentage: 0)
}

struct TimeRead : Codable, Identifiable{
    var id = UUID()
    var startDate : Date
    var endDate : Date?
    
    
    static var test : TimeRead {
        TimeRead(startDate: Date.now)
    }
    static var mainDefault : TimeRead {
        TimeRead(startDate: Date.now, endDate: Date.now)
    }
}
