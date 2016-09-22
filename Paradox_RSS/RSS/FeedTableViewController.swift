//
//  TableTableViewController.swift
//  RSS
//
//  Created by Austin Eckman on 11/27/14.
//  Copyright (c) 2014 Austin Eckman. All rights reserved.
//

import UIKit
import CoreData
import iAd

class FeedTableViewController: UITableViewController, ADBannerViewDelegate, NSXMLParserDelegate, SideBarDelegate {
    
    var parser = NSXMLParser() //Parser
    var feeds = NSMutableArray() //Feed list
<<<<<<< Updated upstream
    var elements = NSMutableDictionary() //feed elements
    var element = NSString() //feed elements1
    var ftitle = NSMutableString() //feed title
    var link = NSMutableString() //feed link
    var date = NSMutableString() //feed date
    var fdescription = NSMutableString() //feed description
    var sidebar = SideBar() //sidebar
    var savedFeeds = [Feed]() //sidebar saved feeds (core)
    var feedNames = [String]() //sidebar feed names
    var currentFeedTitle = String() //current feed title
    var currentFeedLink = String() //current feed link
    var holdinglink = String() //error reverse title
    var sidebarindex = Int() //index 0 add feeds; 1 favs ; 2 all feeds



=======
    var elements = NSMutableDictionary() //Feed elements
    var element = NSString() //Feed elements1
    var ftitle = NSMutableString() //Feed title
    var link = NSMutableString() //Feed link
    var date = NSMutableString() //Feed date
    var fdescription = NSMutableString() //Feed description
    var sidebar = SideBar() //Sidebar
    var savedFeeds = [Feed]() //Sidebar saved feeds (core)
    var feedNames = [String]() //Sidebar feed names
    var currentFeedTitle = String() //Current feed title
    var currentFeedLink = String() //Current feed link
    var holdinglink = String() //Rrror reverse title
    var sidebarindex = Int() //index 0 add feeds; 1 favs ; 2 Any feed
    var UIiAd: ADBannerView = ADBannerView() //Displays ads at the bottom
    
    
    //Pull to refresh
>>>>>>> Stashed changes
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    //viewDidLoad method
    
    override func viewDidLoad() {
        
        //Refreshing enabled
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        super.viewDidLoad()
        
        //iAd banner
        self.canDisplayBannerAds = true
 
        //Feeds
        request(nil)
        loadSavedFeeds()
        
    }
    
    //BEGIN PARSER CODE
    
    //Request method for parsing
    func request(urlString:String?){
        
        //Blank URL run nil
        if urlString == nil{

            
            //DEFAULT LINK
            let url = NSURL(string: "http://feeds.nytimes.com/nyt/rss/Technology")
            self.title = "New York Times Technology"
            currentFeedLink = "http://feeds.nytimes.com/nyt/rss/Technology"
            feeds = []
            parser = NSXMLParser(contentsOfURL: url)!
            parser.delegate = self
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.shouldResolveExternalEntities = true
            parser.parse()
            tableView.reloadData()
            
        }else{
            
            
            //USER LINK
            let url = NSURL(string: urlString!)
            self.title = currentFeedTitle
            feeds = []
            parser = NSXMLParser(contentsOfURL: url)!
            parser.delegate = self
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.shouldResolveExternalEntities = true
            parser.parse()
            
            
            //Error message for feeds that dont return anything
            if feeds == [] && self.currentFeedLink != "http://feeds.nytimes.com/nyt/rss/Technology"{
                let alertTwo = UIAlertController(title: "Alert!", message: "The feed you clicked on presented zero feeds. Please check your internet connectivity or try another feed.", preferredStyle: UIAlertControllerStyle.Alert)
                alertTwo.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alertTwo, animated: true, completion: nil)
               // self.title = "New York Times Technology"
                self.request(nil)

           }
            
        }
        
        
    }


    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        element = elementName
        
        // Feed properties
        
        /*

        Prepares the strings for being parsed. Sets location for new title, link, date, description.

        */
        if (element as NSString).isEqualToString("item"){
            elements = NSMutableDictionary.alloc()
            elements = [:]
            ftitle = NSMutableString.alloc()
            ftitle = ""
            link = NSMutableString.alloc()
            link = ""
            fdescription = NSMutableString.alloc()
            fdescription = ""
            date = NSMutableString.alloc()
            date = ""

            


        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        //Setting the object from the found key in the string. This take the data from the parser and returns it into the elements.

        
        if (elementName as NSString).isEqualToString("item") {
            if ftitle != ""{
                elements.setObject(ftitle, forKey: "title")
            
        }
            if link != ""{
                elements.setObject(link, forKey: "link")
            
        }
            if fdescription != ""{
                elements.setObject(fdescription, forKey: "description")
            
        }

            if date != ""{
                elements.setObject(date, forKey: "pubDate")
                
        }

           
        feeds.addObject(elements)

    }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        //For the found characters append string
        
        if element.isEqualToString("title"){
            ftitle.appendString(string)
        } else if element.isEqualToString("link"){
            link.appendString(string)
        } else if element.isEqualToString("description"){
            fdescription.appendString(string)
        } else if element.isEqualToString("pubDate"){
            date.appendString(string)
        }
        
    
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        self.tableView.reloadData()
    }
    
    //END PARSER CODE

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSavedFeeds (){
        
        //Grab an array of feeds
        savedFeeds = [Feed]()
        
        //Get feed names to an array of strings
        feedNames = [String]()
        
        //Add "Add Feed" into feednames because it's not in there
        feedNames.append("Add Feed")
        feedNames.append("Favorites")
        
        //Contacts core data for feeds list
        let moc = SwiftCoreDataHelper.managedObjectContext()
        let results = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Feed), withPredicate: nil, managedObjectContext: moc)
        if results.count > 0 {
            for feed in results{
                let f = feed as Feed
                savedFeeds.append(f)
                feedNames.append(f.name)
                
            }
        }
        
        //Fill menu items with feedNames
        sidebar = SideBar(sourceView: self.navigationController!.view, menuItems: feedNames)
        sidebar.delegate = self
        
    }
    
    
    //BEGIN SIDEBAR PROGRAMMING
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        //checks to see what side bar button was pressed
        
        if index == 0{ //Add feed button was pressed
            sidebarindex = 2
<<<<<<< Updated upstream
=======
            
            //Alert for new news feeds
>>>>>>> Stashed changes
            let alert = UIAlertController(title: "Create A New Feed", message: "Enter the name and URL of the feed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField:UITextField!) -> Void in
                textField.placeholder = "Feed Name"
            })
            alert.addTextFieldWithConfigurationHandler({ (textField:UITextField!) -> Void in
                textField.placeholder = "Feed URL"
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction!) -> Void in
                let textFields = alert.textFields
                let feedNameTextField = textFields?.first as UITextField
                let feedURLTextField = textFields?.last as UITextField
                
                //If feed name is filled out, insert into core data
                if feedNameTextField.text != "" && feedURLTextField.text != "" {
                    let moc = SwiftCoreDataHelper.managedObjectContext()
                    
                    let feed = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Feed), managedObjectConect: moc) as Feed
                    feed.name = feedNameTextField.text
                    feed.url = feedURLTextField.text
                    SwiftCoreDataHelper.saveManagedObjectContext(moc)

                    //Set title and links to new values
                    self.loadSavedFeeds()
                    self.currentFeedTitle = feedNameTextField.text
                    self.currentFeedLink = feedURLTextField.text
                    self.request(feedURLTextField.text)
                    
                    
                }
                
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else if index == 1{ //Favorites was selected on side bar
            self.title = "Favorites"
            loadSavedFeeds()
            sidebarindex = 1
            
            var favFeeds = [] as NSArray
            let moc = SwiftCoreDataHelper.managedObjectContext()
            let favFetch = NSFetchRequest(entityName: "Favorite")
            if let favS = moc.executeFetchRequest(favFetch, error: nil) as? [Favorite]{
                favFeeds = favS.map{ $0.favoriteTitle}
            }
            self.tableView.reloadData()


        }else if index >= 2{
            sidebarindex = 2
            loadSavedFeeds()
            //Clearly was a feed pressed
<<<<<<< Updated upstream
            //call new MOC
=======
            //Call new MOC
>>>>>>> Stashed changes
            let moc = SwiftCoreDataHelper.managedObjectContext()
            var selectedFeed = moc.existingObjectWithID(savedFeeds[index - 2].objectID, error: nil) as Feed
            
            //Set title
            currentFeedTitle = selectedFeed.name
            currentFeedLink = selectedFeed.url

            
            //Set new url

            request(selectedFeed.url)
            self.tableView.reloadData()

        }
        

        
    }
    
    //END SIDE BAR PROGRAMMING
    
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
     
         if sidebarindex == 1{
        
            let moc = SwiftCoreDataHelper.managedObjectContext()
            var favNames: [String] = []
            let fetchRequestM = NSFetchRequest(entityName:"Favorite")
            if let favs = moc.executeFetchRequest(fetchRequestM, error: nil) as? [Favorite] {
                favNames = favs.map { $0.favoriteTitle }}
            
            if favNames.count != 0{
                return favNames.count //Grabbing the count number of favorites to return
            }else{
                return 0
            }
            
        } else{
        return feeds.count //Grabbing the number of articles to return
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FeedTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        if sidebarindex != 1{
            
            ////////////////// Marked for sidebar index that is not favorites //////////////////
            
            //Setting up cell labels and design
        cell.detailTextLabel?.numberOfLines = 3
        cell.title.text = feeds.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell.subtext.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as? String
        cell.link.text = feeds.objectAtIndex(indexPath.row).objectForKey("link") as? String
        cell.date.text = feeds.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell.favorite.tag = indexPath.row
            
            
            ////////////////// Returns checkmark if read //////////////////
            
            //Sets up core data into array
            var myTitle = feeds.objectAtIndex(indexPath.row).objectForKey("title") as String
            let moc = SwiftCoreDataHelper.managedObjectContext()
            let fetchRequest = NSFetchRequest(entityName:"Read")
            var titleNames: [String] = []
            //Checks to see if current feed is in array if it is return a check mark for Read
            if let reads = moc.executeFetchRequest(fetchRequest, error: nil) as? [Read] {
                // get an array of the 'title' attributes
                titleNames = reads.map { $0.readName }
            }
            if (contains(titleNames, myTitle)){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                //Already contained (Already Read)
            }else{/*Not viewed yet*/}
            
            ////////////////// Returns goldstar if favorited //////////////////
            let selectedFavorite = UIImage(named: "GoldStar") as UIImage!
            let notFavorite = UIImage(named: "FavoriteStar") as UIImage!
            let favURL: String = feeds[indexPath.row].objectForKey("link") as String
            var myFav = myTitle
            
            //Fetch request
            let fetchRequestTwo = NSFetchRequest(entityName:"Favorite")
            var favNames: [String] = []
            if let favs = moc.executeFetchRequest(fetchRequestTwo, error: nil) as? [Favorite] {
                favNames = favs.map { $0.favoriteTitle } //Array of title attribute
            }
            if contains(favNames, myFav){
                //true
                cell.favorite.setImage(selectedFavorite, forState: .Normal)
            }else{
                //false
                cell.favorite.setImage(notFavorite, forState: .Normal)
            }
            
            
            ////////////////// End (Return cell) //////////////////
            
        } else{
            
            ////////////////// Marked for sidebar index that is favorites //////////////////

            //Preparing variables to use in core data (All arrays)
        var favoriteNames: [String] = []
        var favoriteLink: [String] = []
        var favoriteDesc: [String] = []
        var favoriteDate: [String] = []

            //Setting up cell labels and design (from core data now)
        let moc = SwiftCoreDataHelper.managedObjectContext()
            //Fetch request
        let fetchRequestFav = NSFetchRequest(entityName: "Favorite")
        let sortDescriptor = NSSortDescriptor(key: "favoriteTitle", ascending: true)
        fetchRequestFav.sortDescriptors = [sortDescriptor]
        if let favsLoad = moc.executeFetchRequest(fetchRequestFav, error: nil) as? [Favorite]{
            favoriteNames = favsLoad.map { $0.favoriteTitle}
            favoriteLink = favsLoad.map { $0.favoriteLinks}
            favoriteDesc = favsLoad.map { $0.favoriteDesc}
            favoriteDate = favsLoad.map { $0.favoriteDate}
            }
 
            
            if favoriteNames.count > 0{ //Make sure there are favorites to return
            
                //Setting up labels
            cell.detailTextLabel?.numberOfLines = 3
            cell.title.text = favoriteNames[indexPath.row]
            cell.link.text = favoriteLink[indexPath.row]
            cell.subtext.text = favoriteDesc[indexPath.row]
            cell.date.text = favoriteDate[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
            cell.favorite.tag = indexPath.row
            
            ////////////////// Returns checkmark if read //////////////////
            
            //Sets up core data into array
            var myTitle = favoriteNames[indexPath.row]
            let fetchRequest = NSFetchRequest(entityName:"Read")
            var titleNames: [String] = []
            //Checks to see if current feed is in array if it is return a check mark for Read
            if let reads = moc.executeFetchRequest(fetchRequest, error: nil) as? [Read] {
                //Get an array of the 'title' attributes
                titleNames = reads.map { $0.readName }
            }
            if (contains(titleNames, myTitle)){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                //Already contained (Already Read)
            }else{/*Not viewed yet*/}
            
                ////////////////// Returns goldstar if favorited //////////////////
            let selectedFavorite = UIImage(named: "GoldStar") as UIImage!
            let notFavorite = UIImage(named: "FavoriteStar") as UIImage!
            let favURL = favoriteLink[indexPath.row]
            var myFav = myTitle
                //Fetch request for favorites
            let fetchRequestTwo = NSFetchRequest(entityName:"Favorite")
            var favNames: [String] = []
            if let favs = moc.executeFetchRequest(fetchRequestTwo, error: nil) as? [Favorite] {
                favNames = favs.map { $0.favoriteTitle } //Array of titles attribute
            }
            if contains(favNames, myFav){
                //true
                cell.favorite.setImage(selectedFavorite, forState: .Normal)
            }else{
                //false
                cell.favorite.setImage(notFavorite, forState: .Normal)
            }
            
            }else{/*Blank because 0 articles are favorited */}
            
            ////////////////// End (Return cell) //////////////////
            

        }

        return cell
    }
    
    
        
      override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var accessoryType: UITableViewCellAccessoryType;()

        //Sets up variables
        var fNames: [String] = []
        var fLink: [String] = []
        var fDesc: [String] = []
        var fDate: [String] = []
        var clean: String
        var mTitle: String
        
        
        if sidebarindex != 1{
            
            ////////////////// Marked for sidebar index that is not favorites //////////////////

            
        let selectedFURL: String = feeds[indexPath.row].objectForKey("link") as String
        let selectedTitle: String = feeds[indexPath.row].objectForKey("title") as String
            //Cleans URL
        var dirty = selectedFURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        clean = dirty!.stringByReplacingOccurrencesOfString(
            "%0A",
            withString: "",
            options: .RegularExpressionSearch)
            
        } else {
            
            ////////////////// Marked for sidebar index that is favorites //////////////////

            let moc = SwiftCoreDataHelper.managedObjectContext()
            let fetchRequestFav = NSFetchRequest(entityName: "Favorite")
            let sortDescriptor = NSSortDescriptor(key: "favoriteTitle", ascending: true)
            fetchRequestFav.sortDescriptors = [sortDescriptor]
            if let favsLoad = moc.executeFetchRequest(fetchRequestFav, error: nil) as? [Favorite]{
                fNames = favsLoad.map { $0.favoriteTitle}} //Array of titles attribute
            if let favsLoad = moc.executeFetchRequest(fetchRequestFav, error: nil) as? [Favorite]{
                fLink = favsLoad.map { $0.favoriteLinks}} //Array of links attribute
            //Cleans URL
            var mTitle = fNames[indexPath.row]
            var dirty = fLink[indexPath.row].stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            clean = dirty!.stringByReplacingOccurrencesOfString(
                "%0A",
                withString: "",
                options: .RegularExpressionSearch)
            
        }
        var con = KINWebBrowserViewController()
        

        
        //Creates usuable url
        var URL = NSURL(string: clean)
        con.loadURL(URL!)
        
        self.navigationController?.pushViewController(con, animated: true)

        //Coredata
        let moc = SwiftCoreDataHelper.managedObjectContext()
        let read = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Read), managedObjectConect: moc) as Read
        if sidebarindex != 1{ //Sidebar is not favorites

        read.readName = feeds[indexPath.row].objectForKey("title") as String
        } else{ //Side bar is favorites (locate from core data)
        read.readName = fNames[indexPath.row]
        }
        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        //Reload table to show check mark (Refresh core data)
        self.tableView.reloadData()

}

}

