//
//  CustomSCNNode.swift
//  Monument
//
//  Created by Ibram Uppal on 4/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class CustomSCNNode: SCNNode {
    
    // PROPERTIES
    var rotationCurrent: Float = 0.0
    var rotationBounce: Float = 0.0
    var whatMenuSpot: Int = 0
    
    var menuSpotMin: Int {
        return whatMenuSpot + 1 // level starts form 1
    }
    
    var menuSpotMax: Int {
        return whatMenuSpot + 4 // 4 sides of the monument
    }
    
    convenience init(create: Bool) {
        self.init()
        
    }
    
    // Methods
    func realign(angleRatio: Float) {
        
        /// this logic decides which direction and which spot are current menu option will rotate to and keeps track of the next type
        if angleRatio > 1 && whatMenuSpot > 0 {
            rotationCurrent += Float._90
            rotationBounce = rotationCurrent + 0.05
            whatMenuSpot -= 1
        } else if angleRatio < -1 && whatMenuSpot < 9 {
            rotationCurrent -= Float._90
            rotationBounce = rotationCurrent - 0.05
            whatMenuSpot += 1
        } else if angleRatio < 1 && angleRatio > -1 {
            rotationBounce = 0
        }
        
        /// reset actions
        self.removeAllActions()
        self.defineActionToRun(from: angleRatio)
    }
    
    private func defineActionToRun(from angleRatio: Float) {
        
        let rotationAxisAngle = SCNVector4(0, 1, 0, rotationCurrent)
        let actionRotate = SCNAction.rotate(toAxisAngle: rotationAxisAngle, duration: 0.2)
        actionRotate.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let bounceAxisAngle = SCNVector4(0, 1, 0, rotationBounce)
        let actionBounce = SCNAction.rotate(toAxisAngle: bounceAxisAngle, duration: 0.1)
        actionBounce.timingMode = SCNActionTimingMode.easeInEaseOut
        
        if angleRatio > 1 && whatMenuSpot > 0 ||
            angleRatio < -1 && whatMenuSpot < 9 {
           
            let actionToRun: SCNAction = angleRatio > 2 || angleRatio < -2 ? actionRotate : SCNAction.sequence([actionRotate, actionBounce, actionRotate])
            self.runAction(actionToRun)
        } else {
            self.runAction(actionRotate)
        }
    }
    
    func panBeginMoved(_ xTranslationToCheckNegative: Float) {
        
        let maxToCheckAgainst: Int = xTranslationToCheckNegative > 0 ? menuSpotMax - 1 : menuSpotMax
        
        let minToCheckAgainst: Int = xTranslationToCheckNegative > 0 ? menuSpotMin - 1 : menuSpotMin
       
        for i in 1...10 {
            let nodeGet = self.childNode(withName: "MenuItem\(i)", recursively: true)
            if let node = nodeGet {
                node.isHidden = !(i >= minToCheckAgainst && i <= maxToCheckAgainst)
                
                print("BOOLEAN = \(!(i >= minToCheckAgainst && i <= maxToCheckAgainst)) minToCheckAgainst = \(minToCheckAgainst) , maxToCheckAgainst = \(maxToCheckAgainst) whatMenuSpot = \(whatMenuSpot) ")
            }
        }
    }
    
}













