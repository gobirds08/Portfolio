//
//  BooksManager.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/28/24.
//

import Foundation
import SwiftData
import SwiftUI

class BooksManager : ObservableObject{
    @Published var bookToShow : UserBook = UserBook.mainDefault
    @Published var showBook : Bool = false
    @Published var booksToShow : [UserBook] = []
    @Published var showSearchResults : Bool = false
    let bookRetieval = BookRetrieval()


    func changeBook(book: UserBook){
        bookToShow = book
    }
    
    func searchShelves(query: String, lists: [BookList]) -> Bool{
        let allowed = CharacterSet.alphanumerics
        let query = query.components(separatedBy: allowed.inverted).joined()
        for list in lists{
            for book in list.books{
                let title = book.book.title.components(separatedBy: allowed.inverted).joined()
                if((title.lowercased() == query.lowercased()) || (book.book.isbn == query)){
                    self.bookToShow = book
                    self.showBook = true
                    return true
                }
            }
        }
        return false
    }
    
    func search(query: String, lists: [BookList]){
        if(searchShelves(query: query, lists: lists)){
            return
        }
        bookRetieval.getBooks(with: query){ books in
            DispatchQueue.main.async{
                self.bookToShow = UserBook(userInfo: UserBookInfo.mainDefault, book: books?[0] ?? Book.mainDefault)
                self.showBook = true
            }
        }
    }
    
    func testSearch(query: String, lists: [BookList]){
        if(searchShelves(query: query, lists: lists)){
            return
        }
        bookRetieval.getBooks(with: query){ books in
            DispatchQueue.main.async {
                self.booksToShow.removeAll()
                if(books?.isEmpty ?? true){
                    return
                }
                for book in books!{
                    self.booksToShow.append(UserBook(userInfo: UserBookInfo.mainDefault, book: book))
                }
                self.showSearchResults = true
            }
        }
    }
    
    func isbnSearch(isbn: String, lists: [BookList]){
        let query = "+isbn:\(isbn)"
        search(query: query, lists: lists)
    }
    
    func subjectSearch(subject: String, lists: [BookList]){
        let query = "+subject:\(subject)"
        testSearch(query: query, lists: lists)
    }
    
    func toggleLike(info : Binding<UserBookInfo>){
        info.like.wrappedValue.toggle()
    }
    
    func validListName(lists: [BookList], name: String) -> Bool{
        for list in lists{
            if(list.name == name){
                return false
            }
        }
        return true
    }
    
    func isValidProgress(numString: String) -> Bool{
        let num = Int(numString)
        if(num == nil){
            return false
        }
        if(num! >= 0 && num! <= 100){
            return true
        }
        return false
    }
    
}
