//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Calvin Cantin on 18-10-06.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    var emojis:[[Emoji]] = [[Emoji(symbol: "😀", name: "Grinning Face",description: "A typical smiley face.", usage:"happiness"),
         Emoji(symbol: "😕", name: "Confused Face",description: "A confused, puzzled face.", usage: "unsurewhat to think; displeasure"),
         Emoji(symbol: "😍", name: "Heart Eyes",description: "A smiley face with hearts for eyes.",usage: "love of something; attractive"),
         Emoji(symbol: "👮", name: "Police Officer",description: "A police officer wearing a blue cap with a goldbadge.", usage: "person of authority")],
        [Emoji(symbol: "🐢", name: "Turtle", description:"A cute turtle.", usage: "Something slow"),
         Emoji(symbol: "🐘", name: "Elephant", description:"A gray elephant.", usage: "good memory")],
        [Emoji(symbol: "🍝", name: "Spaghetti",description: "A plate of spaghetti.", usage: "spaghetti")],
        [Emoji(symbol: "🎲", name: "Die", description: "Asingle die.", usage: "taking a risk, chance; game"),
         Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping")],
        [Emoji(symbol: "📚", name: "Stack of Books",description: "Three colored books stacked on each other.",usage: "homework, studying"),
         Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
         Emoji(symbol: "💤", name: "Snore",description:"Three blue \'z\'s.", usage: "tired, sleepiness"),
         Emoji(symbol: "🏁", name: "Checkered Flag",description: "A black-and-white checkered flag.", usage:"completion")]]
        {
        didSet
        {
            Emoji.saveToFile(emojis: emojis)
        }
    }
    @IBAction func unwindToEmojiTableViewController(segue:UIStoryboardSegue)
    {
        guard segue.identifier == "saveUnwind" else{return}
        
        let sourceViewController = segue.source as! AddEmojiTableViewController
        if let emoji = sourceViewController.emoji
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                emojis[indexPath.section][indexPath.row] = emoji
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            else
            {
                let newIndexPath = IndexPath(row: emojis[0].count, section: 0)
                emojis[0].append(emoji)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    @IBAction func editCellButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let loadedEmoji = Emoji.loadFromFile()
        {
        if loadedEmoji.isEmpty
        {
            emojis = Emoji.simpleEmoji()
        }
        else
        {
            emojis = loadedEmoji
        }
        }
        else
        {
            emojis = Emoji.simpleEmoji()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojis.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell

        // Configure the cell...
        let emoji = emojis[indexPath.section][indexPath.row]
        
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            emojis[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            
        }
    }
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEmoji"
        {
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = emojis[indexPath.section][indexPath.row]
            let navigationController = segue.destination as! UINavigationController
            let addEditTableViewController = navigationController.topViewController as! AddEmojiTableViewController
            addEditTableViewController.emoji = emoji
            
            
        }
    }
    
}

