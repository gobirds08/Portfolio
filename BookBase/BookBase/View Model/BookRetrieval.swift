//
//  BookRetrieval.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/28/24.
//

import Foundation

class BookRetrieval{
    func getBooks(with query: String, completion: @escaping ([Book]?) -> Void){
        let apiKey = "not_real_api_keys"
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)&maxResults=40&key=\(apiKey)") else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let data = data, error == nil else{
                completion(nil)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(Response.self, from: data)
                completion(data.items)
            }catch{
                print(error)
                completion(nil)
            }
        }
   
        task.resume()
    }
}
