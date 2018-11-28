//
//  MainTableViewCell.swift
//  ios-book-melchizedek
//
//  Created by User on 2018-11-26.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    var item : NSManagedObject!
    
    func setItem(item: NSManagedObject){
        self.item = item
        if (titleLabel != nil){
            updateView()
        }
    }
    
    override func didMoveToWindow() {
        updateView()
    }
    
    func updateView(){
        titleLabel.text = item.value(forKey: "title") as? String
        contentText.text = item.value(forKey: "text") as? String
        contentText.isScrollEnabled = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
