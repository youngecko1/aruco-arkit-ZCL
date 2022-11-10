//
//  ArucoNode.swift
//  ARUcoTest
//

import Foundation
import ARKit

class ArucoNode : SCNNode {
    var size:CGFloat;
    public let id:Int;
    var view: UIView!
    var sceneView: ARSCNView!
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    var popUp: CustomPopUp!
    
    var vc: ViewController!
    
    var productID: String!

    init(sz:CGFloat = 0.04, arucoId:Int = 23, vw: UIView, scnvw: ARSCNView, vc: ViewController) {
        
        
        
        self.size = ArucoProperty.ArucoMarkerSize
        self.id = arucoId
        
        self.view = vw
        self.sceneView = scnvw
        
        self.vc = vc
        
        self.popUp = CustomPopUp(frame: self.view.frame, arucoId: self.id, vc: self.vc)
        self.popUp.view.layer.cornerRadius = 5
        
        super.init()
        
        
        let planeGeometry = SCNPlane(width: size*2, height: size*2)

        button.configuration = UIButton.Configuration.filled()
        
        button.setTitle(productID, for: .normal)

        button.titleLabel?.font = button.titleLabel?.font.withSize(100)
        
        button.titleLabel?.sizeToFit()

        let buttonMaterial = SCNMaterial()

        buttonMaterial.diffuse.contents = button

        let planeNode = SCNNode(geometry: planeGeometry)

        planeNode.geometry?.firstMaterial = buttonMaterial

        self.addChildNode(planeNode)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    @objc func buttonTapped(_ sender: Any){
        self.vc.buttonIsPressed = true
        print("Button tapped")
        
        self.view.addSubview(popUp)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

