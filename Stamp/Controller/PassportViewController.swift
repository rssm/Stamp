//
//  PassportViewController.swift
//  Stamp
//
//  Created by Rafael Sol Santos Martins on 10/08/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import UIKit
import CoreLocation

class PassportViewController: UIViewController {

//    dados para localização
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark : CLPlacemark?
    
//    variaveis default para preencher carimbo, que são atualizadas conforme novo carimbo.
    var city : String = "Gotham"
    var country : String = "USA"
    var stringDate : String?
    
//    imagem de fundo estilo passaporte
    @IBOutlet weak var backgroundPageImageView: UIImageView!
    
    var stampViews = [UIView]()
    var stampDatas = [StampData]()
    
    var enableStampBool : Bool = false
    var firstStampBool : Bool = true
    
    var addButtonItem : UIBarButtonItem?
    var doneButtonItem: UIBarButtonItem?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(enableStamp))
        
        self.doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(desenableStamp))
        
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        
        let date = Date()
        let formater = DateFormatter()
        
//        recupera carimbos do user default e os coloca na tela.
        
        if let dataRetrieved = userDefaults.data(forKey: "Stamps"){
            
            let stampArray = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, StampData.self], from: dataRetrieved) as! [StampData]
            
            self.stampDatas = stampArray
            
            for stamp in stampArray{
                let sView = StampView()
                sView.setData(data: stamp)
                self.view.addSubview(sView)
            }
        }
        
        formater.dateFormat = "dd/MM/yyyy"
        
        self.stringDate = formater.string(from: date)
        
//        usar localização em foreground
        self.locationManager.requestWhenInUseAuthorization()
        
//        setando delegate e precisão caso a localização seja autorizada.
        startLocationManager()
        
//        adicionar aleta para caso o usuário recuse localização
        
    }
    

//   recebe um clique na tela, pega a posição do mesmo e adiciona o centro do carimbo na posição
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.enableStampBool{
            if let touch = touches.first {
                let position = touch.location(in: self.view)
                
//                preenche os dados do carimbo
                let data = StampData(city: self.city, country: self.country, date: self.stringDate!, centerX: Double(position.x) , centerY: Double(position.y))
                let stampView = StampView()
                stampView.setData(data: data)
                
//                verifica se não esta reposicionando.
                if !self.firstStampBool{
                    self.stampViews.popLast()?.removeFromSuperview()
                    _ = self.stampDatas.popLast()
                }
//                adiciona o carimbo a tela.
                self.stampViews.append(stampView)
                self.stampDatas.append(data)
                self.view.addSubview(stampView)
                self.firstStampBool = false
                
                let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: self.stampDatas as Array, requiringSecureCoding: false)
                userDefaults.set(encodedData, forKey: "Stamps")
                userDefaults.synchronize()
            }
        }
    }

}

extension PassportViewController : CLLocationManagerDelegate{
    
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
    
//    ativa a atualização da localização, autoriza carimbar, muda o buttonItem e faz a lógica do carimbo.
    @objc func enableStamp(){
        self.startLocationManager()
        self.enableStampBool = !self.enableStampBool
        self.navigationItem.rightBarButtonItem = self.doneButtonItem
        self.firstStampBool = true
    }
    
    //    desativa a atualização da localização, desautoriza carimbar, muda o buttonItem e faz a lógica do carimbo.
    @objc func desenableStamp(){
        self.stopLocationManager()
        self.enableStampBool = !self.enableStampBool
        self.navigationItem.rightBarButtonItem = self.addButtonItem

    }
    
}
