//
//  Overlay.swift
//  RabbitHole
//
//  Created by NMI Capstone on 10/30/18.
//  Copyright © 2018 NMI Capstone. All rights reserved.
//

import Foundation
import UIKit

class Overlay: UIView{
    
    @IBOutlet var tex: UITextField!
    
    var searchTerm = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        frame = CGRect(x: 20, y: 20, width: 300, height: 800)
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .blue
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        tex = UITextField(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        tex.backgroundColor = .white
        
        
        addSubview(button)
        addSubview(tex)
    }

    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        searchTerm = tex.text as! String
        print(searchTerm)
        self.removeFromSuperview()
        
        
    }
   
    
    
}
