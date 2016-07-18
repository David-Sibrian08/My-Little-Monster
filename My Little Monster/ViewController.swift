//
//  ViewController.swift
//  My Little Monster
//
//  Created by Sibrian on 7/15/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupAndAnimateImage()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAndAnimateImage() {
        var imgArray = [UIImage]()
        
        for i in 1...4 {
            let image = UIImage(named: "idle\(i).png")
            imgArray.append(image!)
        }
        
        monsterImage.animationImages = imgArray
        monsterImage.animationDuration = 0.8
        monsterImage.animationRepeatCount = 0
        monsterImage.startAnimating()
    }

}

