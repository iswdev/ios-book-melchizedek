//
//  ViewController.swift
//  ios-book-melchizedek
//
//  Created by User on 2018-11-24.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    static var LAST_CHAPTER = "LAST_CHAPTER"
    var content : [NSManagedObject] = []
    var chapter : NSManagedObject!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var descLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (DataSource.chapters.count == 0){
            DataSource.loadData()
        }
        tableVIew.dataSource = self
        if (chapter == nil){
            let defaults = UserDefaults.standard
            let chapterNum = defaults.integer(forKey: MainViewController.LAST_CHAPTER)
            let chapters = DataSource.filterField(entity: "Chapter", field: "number", value: chapterNum)
            if (chapters.count == 0){
                chapter = DataSource.chapters[0]
            }else{
                chapter = chapters[0]
            }
            setChapter(chapter: chapter)
        }
        
    }
    
    func setChapter(chapter: NSManagedObject){
        let number = chapter.value(forKey: "number") as! Int
        let defaults = UserDefaults.standard
        defaults.set(number, forKey: MainViewController.LAST_CHAPTER)
        
        self.chapter = chapter
        setContent(content: DataSource.filterField(entity: "Content", field: "chapter", value: number))
    }
    
    func setContent(content: [NSManagedObject]){
        self.content = content
        updateView()
    }
    
    func updateView(){
        if (tableVIew != nil){
            let title = chapter.value(forKey: "title") as! String
            let desc = chapter.value(forKey: "desc") as! String
            titleLabel.text = title
            descLabel.text = desc
            tableVIew.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
    }

    @IBAction func onButtonClick(_ sender: Any) {
        let button = sender as! UIButton
        let chapterNum = chapter.value(forKey: "number") as! Int
        if button == prevButton {
            let newChapter = DataSource.filterField(entity: "Chapter", field: "number", value: chapterNum-1)
            if newChapter.count == 1 {
                setChapter(chapter: newChapter[0])
            }
        }
        if button == nextButton {
            let newChapter = DataSource.filterField(entity: "Chapter", field: "number", value: chapterNum+1)
            if newChapter.count == 1 {
                setChapter(chapter: newChapter[0])
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let newView = segue.destination as! MainViewController
        if let currentChapter = chapter {
            let chapterNum = currentChapter.value(forKey: "number") as! Int
            if button.tag == 101 {
                let newChapter = DataSource.filterField(entity: "Chapter", field: "number", value: chapterNum-1)
                if newChapter.count == 1 {
                    newView.setChapter(chapter: newChapter[0])
                }
            }
            if button.tag == 102 {
                let newChapter = DataSource.filterField(entity: "Chapter", field: "number", value: chapterNum+1)
                if newChapter.count == 1 {
                    newView.setChapter(chapter: newChapter[0])
                }
            }
            if var viewControllers = navigationController?.viewControllers {
                viewControllers.remove(at: viewControllers.count-1)
                navigationController?.viewControllers = viewControllers
            }
            
        }
        
    }
    

}


extension MainViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
        cell.setItem(item: content[indexPath.row])
        return cell
    }
    
    
}
