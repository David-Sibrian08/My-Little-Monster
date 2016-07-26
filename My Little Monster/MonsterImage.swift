//
//  MonsterImage.swift
//  My Little Monster
//
//  Created by Sibrian on 7/21/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    
    //required
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //required!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "idle1.png")
        self.animationImages = nil
        var imgArray = [UIImage]()
        
        for i in 1...4 {
            let image = UIImage(named: "idle\(i).png")
            imgArray.append(image!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        self.image = UIImage(named: "dead4.png")
        
        self.animationImages = nil
        
        func setupAndAnimateImage() {
            var imgArray = [UIImage]()
            
            for i in 1...4 {
                let image = UIImage(named: "dead\(i).png")
                imgArray.append(image!)
            }
            
            self.animationImages = imgArray
            self.animationDuration = 0.8
            self.animationRepeatCount = 0
            self.startAnimating()
        }
    }
}