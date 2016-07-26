//
//  DragImage.swift
//  My Little Monster
//
//  Created by Sibrian on 7/20/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView {
    
    //need to know where the image started in order to send it back there
    var originalPosition: CGPoint!
    
    //create the target where the draggable images must be dropped
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPosition = self.center  //the center of the image
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self.superview)     //get the position or location within the view (superview in this case)
            self.center = CGPointMake(position.x, position.y)       //move the image view's center to the new postion
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.locationInView(self.superview?.superview)
            
            //if position of touch is anywhere inside the frame of the target
            if CGRectContainsPoint(target.frame, position) {
                
                //need notification to tell the observer when we have dropped the item on the target. 
                NSNotificationCenter.defaultCenter().postNotification(NSNotification (name: "onTargetDropped", object: nil))
                
            }
        }
        
        
        //send images to their start point if they were not dropped on the monster
        self.center = originalPosition
        
    }
}