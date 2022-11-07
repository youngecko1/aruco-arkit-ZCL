//
//  ViewController.swift
//  cvAruco
//
//  Created by Dan Park on 3/25/19.
//  Copyright © 2019 Dan Park. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, ARSessionObserver, UISearchResultsUpdating {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var startScanButon: UIButton!
    @IBOutlet weak var stopScanButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchController = UISearchController()
    var isScanning = false;
    var mutexlock = false;
    var buttonIsPressed = false
    
    let configuration = ARWorldTrackingConfiguration()
    
    public var db = Firestore.firestore()
    
    var arr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    
    var cabArr: [Cabinet] = []
    
    
    func getDB() -> Firestore {
        return db
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
//        sceneView.showsStatistics = true
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.layer.zPosition = 0
        
        let someURL:URL = URL(string: "www.google.com")!
        let cabinet = Cabinet(id: 1, count: 1, image: someURL, lti: "sasdfasdf", lto: "asdfasdf", lu: "asdf", location: "asdf", pti: "asdf", prodID: "asdf", prodName: "asdf", use: [0], remain: "Hl")
        
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        
        
        if(isScanning && arr.contains(text)){
            let number = Int(text)!
            if let cube = findCube(arucoId: number) {
                cube.button.tintColor = .red
                
            }
            else{
                
                print("Marker Not Within View")
            }
        }
        else{
            for node in sceneView.scene.rootNode.childNodes {
                if node is ArucoNode {
                    let box = node as! ArucoNode
                    box.button.tintColor = .systemBlue
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration

        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.autoenablesDefaultLighting = true;
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func updateContentNodeCache(targTransforms: Array<SKWorldTransform>, cameraTransform:SCNMatrix4) {
        
        for transform in targTransforms {
            
            let targTransform = SCNMatrix4Mult(transform.transform, cameraTransform);
            
//            print(targTransform)
            
            
            if let box = findCube(arucoId: Int(transform.arucoId)) {
                
                print("box within view: " + String(transform.arucoId))

                box.setWorldTransform(targTransform)

                if(!isScanning){
                    box.removeFromParentNode()
                }
                
                if(buttonIsPressed){
                    box.button.isEnabled = false
                }
                else{
                    box.button.isEnabled = true
                }
                
                
            }
            else {
                print("exising aruco node not found. Creating one")
                if(isScanning){
                    let arucoCube = ArucoNode(arucoId: Int(transform.arucoId), vw: view, scnvw: sceneView, vc: self)
                    sceneView.scene.rootNode.addChildNode(arucoCube);
                    arucoCube.setWorldTransform(targTransform)
                    print("Making Cube: ")
                }

                            

            }
        }
    }
    
    func findCube(arucoId:Int) -> ArucoNode? {
        print("finding existing cubes")
        for node in sceneView.scene.rootNode.childNodes {
            if node is ArucoNode {
                let box = node as! ArucoNode
                if (arucoId == box.id) {
                    return box
                }
            }
        }
        return nil
    }
    
    
    @IBAction func startScan(_ sender: Any) {
        sceneView.session.run(configuration, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
        isScanning = true
    }
    
    
    @IBAction func stopScan(_ sender: Any) {
        isScanning = false
        for node in sceneView.scene.rootNode.childNodes {
            if node is ArucoNode {
                node.removeFromParentNode()

            }
        }
    }
    
    
    
    
    
    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        if(!self.isScanning){
            self.mutexlock = false;
            return
        }
//        else{
//            sceneView.session.setWorldOrigin(relativeTransform: frame.camera.transform)
//        }
        
        if self.mutexlock {
            return;
        }

        self.mutexlock = true;
        let pixelBuffer = frame.capturedImage
        
        // 1) cv::aruco::detectMarkers
        // 2) cv::aruco::estimatePoseSingleMarkers
        // 3) transform offset and rotation of marker's corners in OpenGL coords
        // 4) return them as an array of matrixes

        let transMatrixArray:Array<SKWorldTransform> = ArucoCV.estimatePose(pixelBuffer, withIntrinsics: frame.camera.intrinsics, andMarkerSize: Float64(ArucoProperty.ArucoMarkerSize)) as! Array<SKWorldTransform>;

        
        if(transMatrixArray.count == 0) {
            self.mutexlock = false;
            return;
        }

        let cameraMatrix = SCNMatrix4.init(frame.camera.transform);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.updateContentNodeCache(targTransforms: transMatrixArray, cameraTransform:cameraMatrix)
        
            self.mutexlock = false;
        })
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        NSLog("%s", __FUNC__)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    }
    
    // MARK: - ARSessionObserver

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

