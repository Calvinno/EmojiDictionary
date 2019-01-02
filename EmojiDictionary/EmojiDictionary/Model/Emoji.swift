//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Calvin Cantin on 18-10-06.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import Foundation

class Emoji: Codable
{
    var symbol:String
    var name:String
    var description:String
    var usage:String
    static var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var archiveURL = Emoji.documentDirectory.appendingPathComponent("Emoji").appendingPathExtension("plist")
    
    init(symbol:String, name:String,description:String,usage:String)
    {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
    static func saveToFile(emojis: [[Emoji]])
    {
        let emojiEncoder = PropertyListEncoder()
        let encodedEmoji = try? emojiEncoder.encode(emojis)
        
        try? encodedEmoji?.write(to: archiveURL)
    }
    static func loadFromFile() ->[[Emoji]]?
    {
        let emojiDecoder = PropertyListDecoder()
        
        if let retrievedEmoji = try? Data(contentsOf: archiveURL)
        {
        if let decodedEmojis = try? emojiDecoder.decode(Array<Array<Emoji>>.self, from: retrievedEmoji)
        {
            return decodedEmojis
        }
        }
        return nil
    }
    static func simpleEmoji() -> [[Emoji]]
    {
        let emojiTableviewController = EmojiTableViewController()
        let emojis = emojiTableviewController.emojis
        return emojis
    }
}
