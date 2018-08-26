//
//  GameViewController.swift
//  Monument
//
//  Created by Ibram Uppal on 11/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

let artConstants = ArtConstants()

class GameViewController: UIViewController {
    
    var sceneView: SCNView?
    let scene = MonumentScene(create: true)
    let scene2 = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        
        if let view = sceneView {
            
            view.scene = scene
            view.isPlaying = true
            view.backgroundColor = UIColor.white
            view.antialiasingMode = SCNAntialiasingMode.multisampling2X
             
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            view.addGestureRecognizer(panGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func handlePan(gestureRecognize: UIPanGestureRecognizer) {
        
        let xTranslation = Float(gestureRecognize.translation(in: gestureRecognize.view!).x)
        
        /// this will hide the node to display more tha 4..
        switch gestureRecognize.state {
        case .began:
             scene.towerAttach.panBeginMoved(xTranslation)
        default:
            break
        }
        
        // rotation animation
        /// define an angle
        var angle: Float = (xTranslation * Float.pi) / 700.0
        
        /// define of its greater tha 45 degrees FLoat.pi is like 180 degrees
        let angleRatio = angle / (Float._45)
        angle += scene.towerAttach.rotationCurrent
        scene.towerAttach.rotation = SCNVector4(0, 1, 0, angle)
        
        switch gestureRecognize.state {
        case .ended, .cancelled:
            scene.towerAttach.realign(angleRatio: angleRatio)
        default:
            break
        }
    }
    
    @objc func handleTap(gestureRecognize: UIPanGestureRecognizer) {

        // MARK:- Changing scenes not good, this way not recommended, but we can use the node name etc, research more...
        if let view = sceneView {
            view.scene = scene2
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden:  Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}


extension Float {
    
    static var _180: Float {
        return Float.pi
    }
    
    static var _90: Float {
        return Float.pi / 2
    }
    
    static var _45: Float {
        return Float.pi / 4
    }
}






