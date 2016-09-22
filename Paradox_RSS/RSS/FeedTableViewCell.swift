//
//  FeedTableViewCell.swift
//  RSS
//
//  Created by Austin Eckman on 2/13/15.
//  Copyright (c) 2015 Austin Eckman. All rights reserved.
//

import UIKit

var logItems = NSManagedObject() //Used in upcoming core data to move things around better


class FeedTableViewCell: UITableViewCell { //Setting up cell
    
<<<<<<< Updated upstream
    @IBOutlet weak var date: UILabel! //date of article
    @IBOutlet weak var link: UILabel! //Link hidden on cell
    @IBOutlet weak var subtext: UILabel! //description of article
    @IBOutlet weak var title: UILabel! //title of article
    @IBOutlet weak var favorite: UIButton! //favorite button
    @IBAction func favoriteButton(sender: AnyObject) { //favoritebutton action
=======
    @IBOutlet weak var date: UILabel!                   //Date of article
    @IBOutlet weak var link: UILabel!                   //Link hidden on cell
    @IBOutlet weak var subtext: UILabel!                //Description of article
    @IBOutlet weak var title: UILabel!                  //Title of article
    @IBOutlet weak var favorite: UIButton!              //Favorite button
    
    
    
    @IBAction func favoriteButton(sender: AnyObject) {  //Favorite Button action
>>>>>>> Stashed changes
        let favorite: UIButton = sender as UIButton
        let selectedFavorite = UIImage(named: "GoldStar") as UIImage! //image: GoldStar
        let notFavorite = UIImage(named: "FavoriteStar") as UIImage! //image: FavoriteStar (non gold)
        
        //Sets up variables with the cell information
        var myFav = title.text!
        var myDesc = subtext.text!
        var myLink = link.text!
        var myDate = date.text!
<<<<<<< Updated upstream
        //begin core data
=======
        
        //Begin core data
>>>>>>> Stashed changes
        let moc = SwiftCoreDataHelper.managedObjectContext()
        var favNames: [String] = []
        
        let fetchRequestM = NSFetchRequest(entityName:"Favorite") //Fetch core data
        
        let fetchRequest = NSFetchRequest(entityName:"Favorite")  //Fetch core data
        let sortDescriptor = NSSortDescriptor(key: "favoriteLinks", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor] //Good practice to make favoritelinks ascending
        let predicateOnTitle = NSPredicate(format: "favoriteTitle = %@", myFav)
        fetchRequest.predicate = predicateOnTitle //Predicate to show only myLink in core data; displays [Array of 1]

        if let favs = moc.executeFetchRequest(fetchRequestM, error: nil) as? [Favorite] {
        // Get an array of the 'title' attributes
            favNames = favs.map { $0.favoriteTitle }
        }
        if contains(favNames, myFav){
            
            //This means the clicked on articles is favorited, so were going to delete it from core data
            favorite.setImage(notFavorite, forState: .Normal)
            if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Favorite] {
            var logItems = fetchResults
            let logItemToDelete = logItems[0] as NSManagedObject
            moc.deleteObject(logItemToDelete)
                
            //Saving
            SwiftCoreDataHelper.saveManagedObjectContext(moc)
                
                /*
                
                Fetchresults will only be equal to the favorite title of the article you picked because
                of the predicateOnTitle. Knowing this will only return an array of 1, we delete the first
                item in the array. This removes it from the core data. Simply sorting our core data to only
                show the one we picked and deleting it.
                
                */
                
            }
            
        }else{//Not yet favorited
            favorite.setImage(selectedFavorite, forState: .Normal)
            //Save to core data
            let fav = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Favorite), managedObjectConect: moc) as Favorite
            
            //Now locating core data to save to
            fav.favoriteLinks = myLink as String
            fav.favoriteDesc = myDesc as String
            fav.favoriteTitle = myFav as String
            fav.favoriteDate = myDate as String
<<<<<<< Updated upstream
=======
            
            //Saving
>>>>>>> Stashed changes
            SwiftCoreDataHelper.saveManagedObjectContext(moc)
        }
        
        
    }
    
    
    
    //EXTRAS : Default code
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

