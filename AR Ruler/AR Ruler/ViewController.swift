//
//  ViewController.swift
//  AR Ruler
//
//  Created by Husain Mustafa on 04/10/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]() //initialized as an empty array
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2
        {
            for dot in dotNodes
            {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]() //reinitialize to an empty array
        }
        
        if let touchLocation = touches.first?.location(in: sceneView)
        {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint) // 3D Location from the world view
            if let hitResult = hitTestResults.first
            {
                addDot(at: hitResult)
            }
        }
    }
    
    func addDot(at hitResult : ARHitTestResult)
    {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate()
    {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = sqrt(
                pow(end.position.x - start.position.x, 2) +
                pow(end.position.y - start.position.y, 2) +
                pow(end.position.z - start.position.z, 2))
        
        updateText(text: "\(abs(distance * 100))", atPosition: end.position)
    }
    
    func updateText(text: String, atPosition position: SCNVector3)
    {
        textNode.removeFromParentNode() // remove text displayed on screen from previous distance measure before displaying new distance measure
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z - 0.1)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01) // Scales down to 1% of origianl size
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
  
}
