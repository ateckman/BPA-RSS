//
//  Read.swift
//  RSS
//
//  Created by Austin Eckman on 2/8/15.
//  Copyright (c) 2015 Austin Eckman. All rights reserved.
//
/*

    This file is to simply allow for the developer to easily change the database file
    so testing with core data quicker. No need to remove anything just change the database.sqlite
    name to something unique.

    Allows for functions; insertManagedObjectContext (adding) , fetchEntities (grabbing core data), and
    saveManagedObjectContext (saving).

*/
import UIKit
import CoreData

class SwiftCoreDataHelper: NSObject {
   
    class func directoryForDatabaseFilename()->NSString{
        
        //directory location
        return NSHomeDirectory().stringByAppendingString("/Library/Private Documents")
    }
    

    class func databaseFilename()->NSString{
<<<<<<< Updated upstream
        return "database33.sqlite";
=======
        //set up database name
        return "database33.sqlite"
>>>>>>> Stashed changes
    }
    
    
    class func managedObjectContext()->NSManagedObjectContext{

        //error handling
        var error:NSError? = nil
        
        NSFileManager.defaultManager().createDirectoryAtPath(SwiftCoreDataHelper.directoryForDatabaseFilename(), withIntermediateDirectories: true, attributes: nil, error: &error)

        let path:NSString = "\(SwiftCoreDataHelper.directoryForDatabaseFilename()) + \(SwiftCoreDataHelper.databaseFilename())"
        
        let url:NSURL = NSURL(fileURLWithPath: path)!
        
        let managedModel:NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!
        
        //storing configurations
        var storeCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        
        if storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error:&error ) != nil{
            if error != nil{
                println(error!.localizedDescription)
                abort()
            }
        }
        //MOC settings for store coordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        return managedObjectContext
        
        
    }
    
    //adding core data with insert function
    class func insertManagedObject(className:NSString, managedObjectConect:NSManagedObjectContext)->AnyObject{
    
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectConect) as NSManagedObject
        
        return managedObject
        
    }
    
    //saving core data
    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        if managedObjectContext.save(nil){
            return true
        }else{
            return false
        }
    }

    //fetching core data
    class func fetchEntities(className:NSString, withPredicate predicate:NSPredicate?, managedObjectContext:NSManagedObjectContext)->NSArray{
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)!
        
        fetchRequest.entity = entetyDescription
        if predicate != nil{
            fetchRequest.predicate = predicate!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        let items:NSArray = managedObjectContext.executeFetchRequest(fetchRequest, error: nil)!
        
        return items
    }
    
    
}
