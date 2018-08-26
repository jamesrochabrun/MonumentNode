//
//  MonumentScene.swift
//  Monument
//
//  Created by Ibram Uppal on 4/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class MonumentScene: SCNScene {
    
    /// Node Container
    let towerAttach = CustomSCNNode(create: true)
    
    convenience init(create: Bool) {
        self.init()
        
        setupLightsAndCamera()
        
        //RETRIEVE AND ADD NODES HERE
        /////////////////////////////
        guard let towerScene = SCNScene(named: "art.scnassets/Tower.dae"),
        let towerNode = towerScene.rootNode.childNode(withName: "Tower", recursively: true) else { return }
        
        guard let menuItemScene = SCNScene(named: "art.scnassets/MenuItems.dae") else { return }
        
        /// get all the nodes
        for i in 1...10 {
            self.addMenuNode(from: menuItemScene, to: towerAttach, at: i)
        }
        
        towerAttach.runAction(SCNAction.scale(by: 0.7, duration: 0))
        towerAttach.addChildNode(towerNode)
        rootNode.addChildNode(towerAttach)
        
    }
    
    ///
    private func addMenuNode(from menuItemScene: SCNScene, to towerAttach: CustomSCNNode,  at number: Int) {
        
        guard let menuItem1 = menuItemScene.rootNode.childNode(withName: "_\(number)", recursively: true) else { return }
        
        menuItem1.runAction(SCNAction.scale(by: 0.15, duration: 0))
        menuItem1.rotation = SCNVector4(1, 0, 0, Float.pi / 2)
        
        /// container node for menu node
        let emptyMenuitem = SCNNode()
        emptyMenuitem.name = "MenuItem\(number)"
        emptyMenuitem.addChildNode(menuItem1)
        
        emptyMenuitem.position = SCNVector3(0, -0.3, 0)
        emptyMenuitem.pivot = SCNMatrix4MakeTranslation(0, 0, -0.3)
        
        let appropiateRotationForNode = Float.pi / 2 * Float(number - 1)
        emptyMenuitem.rotation = SCNVector4(0, 1, 0, appropiateRotationForNode)
        
        emptyMenuitem.isHidden = number > 4
        
        towerAttach.addChildNode(emptyMenuitem)
    }
    
    //ANIMATE SCNTRANSACTION HERE
    /////////////////////////////
    
    func setupLightsAndCamera() {
    
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLight.LightType.spot
        lightNodeSpot.light!.attenuationStartDistance = 2.0
        lightNodeSpot.light!.attenuationFalloffExponent = 2
        lightNodeSpot.light!.attenuationEndDistance = 30
        lightNodeSpot.position = SCNVector3(x: 0, y: 2, z: 1)
        
        let emptyAtCenter = SCNNode()
        emptyAtCenter.position = SCNVector3Zero
        rootNode.addChildNode(emptyAtCenter)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        
        let plane = SCNPlane(width: 4, height: 4)
        plane.firstMaterial!.diffuse.contents = artConstants.returnGradient()
        plane.firstMaterial!.emission.contents = artConstants.returnGradient()
    
        let planeNode = SCNNode(geometry:plane)
        planeNode.position = SCNVector3(x: 0, y: 0, z: -50)
        
        let particleSystem = SCNParticleSystem(named: "Particles.scnp", inDirectory: "")!
        let emptyParticle = SCNNode()
        
        emptyParticle.addParticleSystem(particleSystem)
        particleSystem.warmupDuration = 20.0
        emptyParticle.position = SCNVector3(x: 0, y: -1, z: 0)
        
        rootNode.addChildNode(emptyParticle)
        rootNode.addChildNode(planeNode)
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
    
    }
    
}
