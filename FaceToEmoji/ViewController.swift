//
//  ViewController.swift
//  FaceToEmoji
//
//  Created by Terranz on 20/3/19.
//  Copyright © 2019 terradevteam. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    /* 🙃 👩🏻 */
    
    let sceneView = ARSCNView()
    
    let smileLabel: UILabel = {
        let label = UILabel()
        label.text = "😐"
        label.font = UIFont.systemFont(ofSize: 150)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ARKit
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Device does not support face tracking")
        }
        
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            if granted {
                DispatchQueue.main.sync {
                    self.setupSmileTracker()
                }
            } else {
                fatalError("User did not grant camera permission")
            }
        }
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        let leftSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
        let rightSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
        
        let leftMouthFrownValue = faceAnchor.blendShapes[.mouthFrownLeft] as! CGFloat
        let rightMouthFrownValue = faceAnchor.blendShapes[.mouthFrownRight] as! CGFloat
        
        let leftEyeSquintValue = faceAnchor.blendShapes[.eyeSquintLeft] as! CGFloat
        let rightEyeSquintValue = faceAnchor.blendShapes[.eyeSquintRight] as! CGFloat
        
        let cheekPuffValue = faceAnchor.blendShapes[.cheekPuff] as! CGFloat
        
        let browInnerUpValue = faceAnchor.blendShapes[.browInnerUp] as! CGFloat
        
        let mouthPuckerValue = faceAnchor.blendShapes[.mouthPucker] as! CGFloat
        
        let jawOpenValue = faceAnchor.blendShapes[.jawOpen] as! CGFloat
        
        DispatchQueue.main.async {
            self.handleSmile(leftValue: leftSmileValue, rightValue: rightSmileValue)
            self.handleMouthFrown(leftValue: leftMouthFrownValue, rightValue: rightMouthFrownValue)
            self.handleCheekPuff(cheekPuffValue)
            self.handleBrowInnerUp(browInnerUpValue)
            self.handleMouthPucker(mouthPuckerValue)
            self.handleJawOpen(jawOpenValue)
        }
    }
    
    private func setupSmileTracker() {
        let config = ARFaceTrackingConfiguration()
        sceneView.session.run(config)
        sceneView.delegate = self
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            sceneView.heightAnchor.constraint(equalToConstant: 300),
            sceneView.widthAnchor.constraint(equalToConstant: 150)
            ])
        
        
        view.addSubview(smileLabel)
        NSLayoutConstraint.activate([
            smileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            smileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
            ])
    }
    
    private func handleSmile(leftValue: CGFloat, rightValue: CGFloat) {
        let smileValue = (leftValue + rightValue) / 2
        
        switch smileValue {
        case _ where smileValue > 0.5:
            smileLabel.text = "😁"
        case _ where smileValue > 0.2:
            smileLabel.text = "🙂"
        default:
            smileLabel.text = "😐"
        }
    }
    
    private func handleMouthFrown(leftValue: CGFloat, rightValue: CGFloat) {
        let frownValue = (leftValue + rightValue) / 2
        
        switch frownValue {
        case _ where frownValue > 0.9:
            smileLabel.text = "😧"
        case _ where frownValue > 0.75:
            smileLabel.text = "☹️"
        case _ where frownValue > 0.5:
            smileLabel.text = "🙁"
        default:
            smileLabel.text = "😐"
        }
    }
    
    private func handleCheekPuff(_ cheekPuffValue: CGFloat) {
        if cheekPuffValue > 0.2 {
            smileLabel.text = "🐷"
        }
    }
    
    private func handleBrowInnerUp(_ browInnerUpValue: CGFloat) {
        if browInnerUpValue > 0.2 {
            smileLabel.text = "😟"
        }
    }
    
    private func handleMouthPucker(_ mouthPuckerValue: CGFloat) {
        if mouthPuckerValue > 0.2 {
            smileLabel.text = "😚"
        }
    }
    
    private func handleJawOpen(_ jawOpenValue: CGFloat) {
        if jawOpenValue > 0.2 {
            smileLabel.text = "😮"
        }
    }
}
