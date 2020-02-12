//
//  ViewController.swift
//  RabbitHole
//
//  Created by NMI Capstone on 10/30/18.
//  Copyright © 2018 NMI Capstone. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
    
   
    
  
    var freshToke: String = ""

    var searchString = ""
    
    var searchURL = ""
    
    var names = [String]()
    var ids = [String]()
    
    var nextName = ""
    
    var history = [String]()
    var idList = [String]()
    
    var historyURL = "https://api.spotify.com/v1/playlists/"
    
    var headerz: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + ""]
    
   
    var relURL = "https://api.spotify.com/v1/artists/" + "" + "/related-artists"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        history.removeAll()
        ids.removeAll()
        
        searchString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        searchURL = "https://api.spotify.com/v1/search?q=" + searchString + "&type=artist"
       
         headerz = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer " + freshToke]
        
        reqAlamo(url: searchURL)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    
    
    public func reqAlamo(url: String){
        AF.request(url, headers: headerz).responseJSON { response in
        debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
            
            
            if let artists = wowee["artists"] as? [String:AnyObject]{
                if let items = artists["items"] as? [[String:AnyObject]]{
                for i in 0..<items.count{
                    let item = items[i]
                    
                    let name = item["name"] as! String
                    let id = item["id"] as! String
                    self.names.append(name)
                    self.ids.append(id)
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
            catch{
                print(error)
            }
        }
    }
    
    
    public func buildPlaylist(url:String){
       // AF.request(url, headers: headerz).responseJSON
        
    }
    
    public func reqAlamoID(url: String){
        AF.request(url, headers: headerz).responseJSON { response in
           // debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
                
                
                if let artists = wowee["artists"] as? [[String:AnyObject]]{
                        for i in 0..<artists.count{
                            let item = artists[i]
                            
                            let name = item["name"] as! String
                            let id = item["id"] as! String
                            self.names.append(name)
                            self.ids.append(id)
                            
                            self.tableView.reloadData()
                        }
                    
                    
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiver = segue.destination as! History
        
         let sentInfo = history
            receiver.nameList = sentInfo
        
        let sendo = idList
            receiver.idList = sendo
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = names[indexPath.row]
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.font = UIFont(name: "Menlo-Bold", size: 20)
        if self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular{
            cell?.textLabel?.font = UIFont(name: "Menlo-Bold", size: 30)

        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        
        
        
        nextName = ids[indexPath.row]
        history.append(names[indexPath.row])
        
        idList.append(nextName)
        
        
        names.removeAll()
        ids.removeAll()
        
        print(idList)
        
        relURL = "https://api.spotify.com/v1/artists/" + nextName + "/related-artists"
        reqAlamoID(url: relURL)
        self.tableView.reloadData()
        //print( history)
    }
    
}


