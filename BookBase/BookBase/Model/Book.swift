//
//  Book.swift
//  BookBase
//
//  Created by Brendan Kenney on 3/28/24.
//

import Foundation

public struct Response : Decodable{
    let items : [Book]
}

public struct Book : Codable{
    var title : String
    var subtitle : String?
    var authors : [String]?
    var publishedDate : String?
    var description : String?
    var industryIdentifiers : [IndustryIdentifier]?
    let imageLinks : ImageLinks?
    var isbn : String?{
        return industryIdentifiers?.first(where: {$0.type == "ISBN_10" || $0.type == "ISBN_13"})?.identifier
    }
    
    enum CodingKeys : String, CodingKey{
        case volumeInfo, title, subtitle, authors, publishedDate, description, industryIdentifiers, imageLinks
    }
    
    public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do{
            let volumeInfo = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
            title = try volumeInfo.decodeIfPresent(String.self, forKey: .title) ?? ""
            subtitle = try volumeInfo.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
            authors = try volumeInfo.decodeIfPresent([String].self, forKey: .authors) ?? []
            publishedDate = try volumeInfo.decodeIfPresent(String.self, forKey: .publishedDate) ?? ""
            description = try volumeInfo.decodeIfPresent(String.self, forKey: .description) ?? ""
            industryIdentifiers = try volumeInfo.decodeIfPresent([IndustryIdentifier].self, forKey: .industryIdentifiers) ?? []
            imageLinks = try volumeInfo.decodeIfPresent(ImageLinks.self, forKey: .imageLinks) ?? ImageLinks(smallThumbnail: "", thumbnail: "", small: "", medium: "", large: "", extraLarge: "")
        }catch{
            title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
            subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
            authors = try container.decodeIfPresent([String].self, forKey: .authors) ?? []
            publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate) ?? ""
            description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
            industryIdentifiers = try container.decodeIfPresent([IndustryIdentifier].self, forKey: .industryIdentifiers) ?? []
            imageLinks = try container.decodeIfPresent(ImageLinks.self, forKey: .imageLinks) ?? ImageLinks(smallThumbnail: "", thumbnail: "", small: "", medium: "", large: "", extraLarge: "")
        }
    }
    
    init(title: String, subtitle: String, authors: [String], publishedDate: String, description: String, industryIdentifiers: [IndustryIdentifier], imageLinks: ImageLinks){
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.publishedDate = publishedDate
        self.description = description
        self.industryIdentifiers = industryIdentifiers
        self.imageLinks = imageLinks
    }
    
    static let mainDefault = Book(title: "Not Found", subtitle: "NA", authors: ["NA"], publishedDate: "NA", description: "", industryIdentifiers: [IndustryIdentifier(type: "ISBN_13", identifier: "9780553573404"), IndustryIdentifier(type: "ISBN_10", identifier: "0553573403")], imageLinks: ImageLinks(smallThumbnail: "ImageNA", thumbnail: "ImageNA", small: "", medium: "", large: "", extraLarge: ""))
}

extension Book{
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(subtitle, forKey: .subtitle)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(publishedDate, forKey: .publishedDate)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(industryIdentifiers, forKey: .industryIdentifiers)
        try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
    }

}

public struct IndustryIdentifier : Codable{
    let type : String?
    let identifier : String?
}

public struct ImageLinks : Codable{
    var smallThumbnail : String?
    var thumbnail : String?
    var small : String?
    var medium : String?
    var large : String?
    var extraLarge : String?
    
    enum CodingKeys: CodingKey {
        case smallThumbnail
        case thumbnail
        case small
        case medium
        case large
        case extraLarge
    }
    
    init(smallThumbnail: String, thumbnail: String, small: String, medium: String, large: String, extraLarge: String) {
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
        self.small = small
        self.medium = medium
        self.large = large
        self.extraLarge = extraLarge
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let one = try container.decodeIfPresent(String.self, forKey: .smallThumbnail)
        let two = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        let three = try container.decodeIfPresent(String.self, forKey: .small)
        let four = try container.decodeIfPresent(String.self, forKey: .medium)
        let five = try container.decodeIfPresent(String.self, forKey: .large)
        let six = try container.decodeIfPresent(String.self, forKey: .extraLarge)
        smallThumbnail = fixURL(url: one ?? "")
        thumbnail = fixURL(url: two ?? "")
        small = fixURL(url: three ?? "")
        medium = fixURL(url: four ?? "")
        large = fixURL(url: five ?? "")
        extraLarge = fixURL(url: six ?? "")
    }
    
}

extension ImageLinks{
    mutating func fixURL(url : String) -> String{
        if url.lowercased().hasPrefix("http://") {
            return url.replacingOccurrences(of: "http://", with: "https://")
        }
        return url
    }
}
