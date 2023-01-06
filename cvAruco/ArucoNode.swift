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
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var popUp: CustomPopUp!
    
    var vc: ViewController!
    
    var productID: String!

    init(sz:CGFloat = 0.04, arucoId:Int = 23, vw: UIView, scnvw: ARSCNView, vc: ViewController, arr:Array<Cabinet>) {
        
        self.size = ArucoProperty.ArucoMarkerSize
        self.id = arucoId
        
        self.view = vw
        self.sceneView = scnvw
        
        self.vc = vc
        
        self.popUp = CustomPopUp(frame: self.view.frame, arucoId: self.id, vc: self.vc)
        self.popUp.view.layer.cornerRadius = 5
        
        super.init()
        
        for cabinet in arr {
            if cabinet.aruco_id == arucoId{
                self.productID = cabinet.product_id
            }
        }
        
        
        let planeGeometry = SCNPlane(width: size*3, height: size*3)

        button.configuration = UIButton.Configuration.filled()
        
        button.setTitle(productID, for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
        
//        print(button.titleLabel?.font)

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

