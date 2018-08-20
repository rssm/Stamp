//
//  ViewController.swift
//  Stamp
//
//  Created by Rafael Sol Santos Martins on 08/08/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import ARKit
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate {

    let defaults = UserDefaults.standard
    
    @IBOutlet var sceneView: VirtualObjectARView!
    @IBOutlet weak var addObjectButton: RoundedButton!
    
    //    dados para localização
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark : CLPlacemark?
    
    //    variaveis default para preencher carimbo, que são atualizadas conforme novo carimbo.
    var city : String = "Gotham"
    var country : String = "USA"
    var stringDate : String?
    
    @IBAction func getWorldMap(_ sender: Any) {
        
        switch sceneView.session.currentFrame!.worldMappingStatus {
        case ARFrame.WorldMappingStatus.notAvailable, ARFrame.WorldMappingStatus.limited:
            print("Não rolou")
        case ARFrame.WorldMappingStatus.extending:
            print("Não rolou")
        case ARFrame.WorldMappingStatus.mapped:
            sceneView.session.getCurrentWorldMap { worldMap, error in
                guard let map = worldMap
                    else { print("Error: \(error!.localizedDescription)"); return }
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                    else { fatalError("can't encode map") }
                self.defaults.set(data, forKey:"armap")
            }
        }
    }
    
    var focusSquare = FocusSquare()
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.bepid.stampar")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.frame
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    @IBAction func addObj(_ sender: Any) {
        
        let bounds = sceneView.frame
        let point =  CGPoint(x: bounds.midX, y: bounds.midY)
        
        let test = focusSquare.worldPosition
        
        guard let hitTestResult = sceneView
            .hitTest(point, types: [.featurePoint])
            .first
            else { return }
        
        let transform = hitTestResult.worldTransform
        
        let anchor = ARAnchor(name: "teste", transform: transform)
        sceneView.session.add(anchor: anchor)
        
//        renderObject(at: test)
        
    }
    
    func renderObject(at position: SCNVector3) {

        
//        guard let transform = focusSquare.currentPlaneAnchor?.transform else { return }
        
        let skScene = SKScene(size: CGSize(width: 200, height: 200))
        skScene.backgroundColor = UIColor.clear
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 400, height: 400), cornerRadius: 0)
        rectangle.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rectangle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rectangle.lineWidth = 5
        rectangle.alpha = 0.4
        
        let stamp = StampView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        stamp.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3018077099)
        stamp.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3018077099)
        stamp.contentView.backgroundColor = .clear
        let data = StampData(city: self.city, country: self.country, date: self.stringDate!, centerX: 200, centerY: 100)

        stamp.setData(data: data)
        
//        rectangle.inputView?.addSubview(stamp)
        
//        skScene.view?.addSubview(stamp)
        
        let labelNode = SKLabelNode(text: "Carlos Adão")
        labelNode.fontSize = 20
        labelNode.fontColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        labelNode.position = CGPoint(x: 100,y: 100)
        labelNode.fontName = "SanFrancisco"
        skScene.addChild(rectangle)
//        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 0.2, height: 0.1)
        
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = stamp
        plane.materials = [material]
        
        let childNode = SCNNode(geometry: plane)
        childNode.position = position
        childNode.eulerAngles.x = -.pi / 2
        
        sceneView.scene.rootNode.addChildNode(childNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        // Set up scene content.
        setupCamera()
        sceneView.scene.rootNode.addChildNode(focusSquare)
        
        sceneView.setupDirectionalLighting(queue: updateQueue)
        navigationController?.navigationBar.isHidden = true
        
        let date = Date()
        let formater = DateFormatter()
        
        formater.dateFormat = "dd/MM/yyyy"
        
        self.stringDate = formater.string(from: date)
        
        //        usar localização em foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //        setando delegate e precisão caso a localização seja autorizada.
        startLocationManager()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]

        let data: Data? = defaults.object(forKey: "armap") as? Data
        
        if data != nil {
            if let unarchived = try? NSKeyedUnarchiver.unarchivedObject(of: ARWorldMap.classForKeyedUnarchiver(), from: data!),
                let worldMap = unarchived as? ARWorldMap {
                
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration)
            }
        } else {
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("teste") {
            DispatchQueue.main.async {
                self.renderObject(at: node.position)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        DispatchQueue.main.async {
            self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
            self.updateFocusSquare(isObjectVisible: false)
        }
    }
    
    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
//        virtualObjectInteraction.selectedObject = nil
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
//        statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
    }
    
    // MARK: - Focus Square
    
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
//            statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // Perform hit testing only when ARKit tracking is in a good state.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let result = self.sceneView.smartHitTest(screenCenter) {
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(hitTestResult: result, camera: camera)
            }
//            addObjectButton.isHidden = false
//            statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
//            addObjectButton.isHidden = true
        }
    }
    
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




extension ViewController : CLLocationManagerDelegate{
    
    //    só usar serviço de localização quando usuário clicar para adicionar carimbo.
    func startLocationManager() {
        // always good habit to check if locationServicesEnabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    //    e parar de usar localização quando ele finalizar.
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    //    transforma o dado da localização para Placemark que contem cidade e estado.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = locations.last else { return }
        
        geocoder.reverseGeocodeLocation(locValue) { (placemarks, error) in
            if error == nil, let placemark = placemarks, !placemark.isEmpty{
                self.placemark = placemark.last
                self.city = (self.placemark?.locality)!
                self.country = (self.placemark?.country)!
            }
        }
        
    }
}
