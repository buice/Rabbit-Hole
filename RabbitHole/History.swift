//
//  History.swift
//  RabbitHole
//
//  Created by NMI Capstone on 11/1/18.
//  Copyright © 2018 NMI Capstone. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import WebKit



class History: UIViewController, WKNavigationDelegate{
    
    @IBOutlet weak var webview: WKWebView!
    
    var nameList = [String]()
    var idList = [String]()
    
    var uriList = ""
    

    
    var url = "https://accounts.spotify.com/authorize?client_id=a6d6917a051146bd9f7cc0de547cf2fc&response_type=code&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback&scope=user-read-private%20playlist-modify-public&state=34fFs29kd09"
    

    
    var code1 = ""
    
    var tracklist = [String]()
    
    
    var tokenURL = "https://accounts.spotify.com/api/token"
    
    var tokenHead: HTTPHeaders = ["Authorization": "Basic YTZkNjkxN2EwNTExNDZiZDlmN2NjMGRlNTQ3Y2YyZmM6ZjBhOTQzZjEwOTI4NDhhYzllZTQ0MDFiZjllYzQ0NzU="]
    
    var tokenParm: Parameters = ["grant_type": "authorization_code"]
    
    var freshToke = ""
    
    var userid = ""
    
    var playlistid = ""
    
    var URL2 = "https://api.spotify.com/v1/me"
    
    var URL3 = "https://api.spotify.com/v1/users/{user_id}/playlists"
    
    var URL4 = "https://api.spotify.com/v1/artists/43ZHCT0cAZBISjO8DG9PnE/top-tracks?country=US"
    
    var URL5 = "https://api.spotify.com/v1/playlists/{playlist_id}/tracks?uris="


    
    var plParm: Parameters = ["name": "RabbitHole"]
    
    
    

    
    
    @IBOutlet weak var historyView: UITextView!
    
   
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    
    
    @IBAction func savePL(_ sender: Any) {
        
        webview.isHidden = false
        webview.load(URLRequest(url: URL(string: url)!))
        webview.navigationDelegate = self
        
        
    }
    
    
    func allOfIt(){
        
        webview.isHidden = true
        
        run(after: 2){
        self.tokenHead = ["Authorization": "Bearer " + self.freshToke]
        print(self.tokenHead)
        self.getUser()
        }
        run(after:4){
        self.URL3 = "https://api.spotify.com/v1/users/" + self.userid + "/playlists"
        
       self.tokenHead = ["Authorization": "Bearer " + self.freshToke,
                     "Content-Type": "application/json"]
        
        
        self.buildPL()
        }
        run(after:6){
            
            self.run(after:2){
            self.tokenHead = ["Authorization": "Bearer " + self.freshToke]
            self.URL5 = "https://api.spotify.com/v1/playlists/" + self.playlistid + "/tracks?uris="
        }
            
            
            for i in 0..<self.idList.count{
                self.run(after:2){
                    self.URL4 = "https://api.spotify.com/v1/artists/" + self.idList[i] + "/top-tracks?country=US"
                    print(self.URL4)
                }
                
                self.run(after: 2)
                {
                    self.getTracks()
                    print("URL4 = " + self.URL4)
                    self.tokenHead = ["Authorization": "Bearer " + self.freshToke,
                                      "Content-Type": "application/json"]
                    print("URL5= " + self.URL5)
                    print("PLID= " + self.playlistid)
                    print("URIs= " + self.uriList)
                }
            
        }
        }
        
        
        run(after:20){
        print("URL5 =" + self.URL5)
        self.addTracks()
        }
        
        
        
    }
    
    
    
    
    @IBAction func playlistButton(_ sender: Any) {
        
        
        tokenHead = ["Authorization": "Bearer " + freshToke]
        print(tokenHead)
        getUser()
        

    }
    
    @IBAction func but(_ sender: Any) {
        URL3 = "https://api.spotify.com/v1/users/" + userid + "/playlists"
        
        tokenHead = ["Authorization": "Bearer " + freshToke,
                     "Content-Type": "application/json"]
        
        
        buildPL()
        
        run(after:2){
            self.tokenHead = ["Authorization": "Bearer " + self.freshToke]
            self.URL5 = "https://api.spotify.com/v1/playlists/" + self.playlistid + "/tracks?uris="
            
        
        
        for i in 0..<self.idList.count{
            self.run(after:2){
            self.URL4 = "https://api.spotify.com/v1/artists/" + self.idList[i] + "/top-tracks?country=US"
            print(self.URL4)    
            }
            
        self.run(after: 2)
        {
            self.getTracks()
            print("URL4 = " + self.URL4)
            self.tokenHead = ["Authorization": "Bearer " + self.freshToke,
                              "Content-Type": "application/json"]
            print("URL5= " + self.URL5)
            print("PLID= " + self.playlistid)
            print("URIs= " + self.uriList)
        }
        }
        }
    }
    
    
    @IBAction func butt(_ sender: Any) {
        print("URL5 =" + self.URL5)
        addTracks()
        
    }
    
    
    
    override func viewDidLoad() {
        print(nameList)
        
        super.viewDidLoad()
        
        
        for i in 0..<nameList.count
        {
             historyView.text.append(String(i+1) + " " + nameList[i] + " \n")
        }
        
        webview.isHidden = true


        print("LOOK HERE")
        print(idList)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    let url = webView.url
    print(url as Any) // this will print url address as option field
    if url?.absoluteString.range(of: "example.com/callback") != nil
    {
        print("it worked")
        code1 = getQueryStringParameter(url: (url?.absoluteString)!, param: "code")!
        print("CODE =  " + code1)
        
        tokenParm = ["grant_type": "authorization_code",
                                     "code": code1,
                                     "redirect_uri": "https://example.com/callback"]
        getToken()
        
        allOfIt()
        
  
    }
    
    
    }
    
    func getToken(){
        AF.request(tokenURL, method:.post, parameters: tokenParm, headers: tokenHead).responseJSON { response in
            debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
                
                
                if let toke = wowee["access_token"] as? String{
                    print(toke)
                    
                    self.freshToke = toke
                }
            }
            catch{
                print(error)
            }
        }
        
    }
    
    func getUser(){
        AF.request(URL2, method:.get, headers: tokenHead).responseJSON { response in
            debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
                
                
                if let id = wowee["id"] as? String{
                    print(id)
                    self.userid = id
                    
                }
            }
            catch{
                print(error)
            }
            
        }
        
    }

    
    func buildPL(){
        AF.request(URL3, method:.post, parameters: plParm, encoding: JSONEncoding.default, headers: tokenHead).responseJSON { response in
            debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
                
                
                if let plid = wowee["id"] as? String{
                    print(plid)
                    self.playlistid = plid
                    
                }
            }
            catch{
                print(error)
            }
            
        }
        
}
    
    
    
    func getTracks(){
        AF.request(URL4, method:.get, headers: tokenHead).responseJSON { response in
            debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
                
                if let tracks = wowee["tracks"] as? [[String:AnyObject]]{
                        for i in 0..<tracks.count{
                            let item = tracks[i]
                            
                            let uri = item["uri"] as! String
                            self.URL5.append(uri + ",")
                            self.uriList.append(uri + ",")
                           // self.names.append(name)
                            //self.ids.append(id)
                            
                                }
                    
                    
                }
            }
            catch{
                print(error)
            }
            
            
        }
        
    }
    
    
    func addTracks(){
        AF.request(URL5, method:.post, parameters: plParm, encoding: JSONEncoding.default, headers: tokenHead).responseJSON { response in
            debugPrint(response)
            do{
                var wowee = try JSONSerialization.jsonObject(with :response.data!, options: .mutableContainers) as! [String:AnyObject]
                
                
            }
            catch{
                print(error)
            }
            
        }
        
    }
    
    
    
    
}
