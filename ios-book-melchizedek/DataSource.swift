//
//  DataSource.swift
//  ios-messaging-app
//
//  Created by Francisco Igor on 2018-11-23.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CoreData

class DataSource: NSObject {
    
    static var chapters: [NSManagedObject] = []
    static var contents: [NSManagedObject] = []
    
    static func loadData(){
        chapters = reLoadData(entity: "Chapter")
        contents = reLoadData(entity: "Content")
        
    }
    
    static func reLoadData(entity: String) -> [NSManagedObject]{
        deleteEntities(entity: entity)
        let contents = loadEntities(entity: entity, data: arrayFromJsonFromFile(name: entity))
        //print(contents)
        return contents
    }
    
    
    static func filterField(entity: String, field: String, value: Any) -> [NSManagedObject]{
        let predicate = NSPredicate(format: "\(field) = %@", argumentArray: [value])
        return filterEntities(entity: entity, predicate: predicate)
    }
    
    static func getViewContext() -> NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    static func loadEntities(entity: String, data: NSArray) -> [NSManagedObject]{
        
        var entities: [NSManagedObject] = []
        if let managedContext = getViewContext(){
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
            
            do {
                entities = try managedContext.fetch(fetchRequest)
                if (entities.count == 0){
                    print("Loading \(entity)...")
                    for item in data {
                        let row = item as! NSDictionary
                        createEntity(entity, data:row)
                    }
                    entities = try managedContext.fetch(fetchRequest)
                }
            } catch let error as NSException {
                print("Could not fetch \(entity): \(error) ")
            } catch let error as NSError {
                print("Could not fetch \(entity): \(error), \(error.userInfo)")
            }
        }
        return entities
    }
    
    static func filterEntities(entity: String, predicate: NSPredicate) -> [NSManagedObject]{
        
        var entities: [NSManagedObject] = []
        if let managedContext = getViewContext(){
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
            fetchRequest.predicate = predicate
            do {
                entities = try managedContext.fetch(fetchRequest)
                
            } catch let error as NSError {
                print("Could not fetch \(entity): \(error), \(error.userInfo)")
            }
        }
        return entities
    }
    
    
    static func deleteEntities(entity: String){
        
        var entities: [NSManagedObject] = []
        if let managedContext = getViewContext(){
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
            do {
                entities = try managedContext.fetch(fetchRequest)
                if (entities.count > 0){
                    print("Deleting")
                    for item in entities {
                        managedContext.delete(item)
                    }
                    entities.removeAll()
                }
            } catch let error as NSError {
                print("Could not fetch or delete \(entity): \(error), \(error.userInfo)")
            }
        }
    }
    
    static func createEntity(_ name: String, data: NSDictionary){
        
        if let managedContext = getViewContext(){
            let entity = NSEntityDescription.entity(forEntityName: name, in: managedContext)!
            let newEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            let keys = data.allKeys
            for key in keys{
                let dataKey = key as! String
                newEntity.setValue(data.safeValue(forKey: dataKey, defaultValue: ""), forKeyPath:dataKey)
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
}
