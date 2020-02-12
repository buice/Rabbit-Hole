//
//  ViewController.swift
//  RabbitHole
//
//  Created by NMI Capstone on 10/30/18.
//  Copyright © 2018 NMI Capstone. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class  ViewController: UIViewController {
    
 
    
    @IBOutlet weak var tex: UITextField!
    
    var tokenURL = "https://accounts.spotify.com/api/token"

     let tokenHead: HTTPHeaders = ["Authorization": "Basic YTZkNjkxN2EwNTExNDZiZDlmN2NjMGRlNTQ3Y2YyZmM6ZjBhOTQzZjEwOTI4NDhhYzllZTQ0MDFiZjllYzQ0NzU="]
    
      let tokenParm: Parameters = ["grant_type": "client_credentials"]
    
    var freshToke: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiver = segue.destination as! TableViewController
        
        if let sentInfo = tex.text{
            receiver.searchString = sentInfo
        }
        
        
            receiver.freshToke = freshToke
        
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
    
}
