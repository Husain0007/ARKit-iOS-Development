//
//  ViewController.swift
//  ARDicee
//
//  Created by Husain Mustafa on 11/11/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let sphere = SCNSphere(radius: 0.2)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//        sphere.materials = [material]
        
        // Create a node
        let node = SCNNode()
        node.position = SCNVector3(x: 0.0, y: 0.1, z: -0.5)
        
//        node.geometry = sphere
        sceneView.scene.rootNode.addChildNode(node)
        
        // add lighting for 3D perception of object
        
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "diceCollada copy.scn", recursively: true)
        {
            diceNode.position = SCNVector3(x:0.0, y:0.0, z:-0.1)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
        
        // Set the scene to the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if ARWorldTrackingConfiguration.isSupported{
            
            // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

            // Run the view's session
        sceneView.session.run(configuration)
//        }
//        else
//        {
//            _ = ARSession()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
