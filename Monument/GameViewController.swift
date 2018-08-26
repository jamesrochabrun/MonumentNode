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
            
        }
    }
    
    @objc func handlePan(gestureRecognize: UIPanGestureRecognizer) {
        
        let xTranslation = Float(gestureRecognize.translation(in: gestureRecognize.view!).x)
        
        //HANDLE PAN GESTURE HERE
        /////////////////////////
        // rotation animation
        let angle: Float = (xTranslation * Float.pi) / 700.0
        scene.towerAttach.rotation = SCNVector4(0, 1, 0, angle)
        
        
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
