//
//  RootTableViewCell.swift
//  ios-book-melchizedek
//
//  Created by User on 2018-11-26.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CoreData

class RootTableViewCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var item : NSManagedObject!
    
    func setItem(item: NSManagedObject){
        self.item = item
        if self.titleLabel != nil {
            updateView()
        }
    }
    
    func updateView(){
        titleLabel.text = item.value(forKey: "title") as? String
        descLabel.text = item.value(forKey: "desc") as? String
        iconLabel.text = item.value(forKey: "icon") as? String
    }
    
    override func didMoveToWindow() {
        updateView()
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
