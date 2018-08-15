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
    
//    ainda nao sei... hahaha
//    adicionar os caras aí e remover quando der um novo clique. SHOWZERA
    var stampViews = [UIView]()
    
    var enableStampBool : Bool = false
    
    var addButtonItem : UIBarButtonItem?
    var doneButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(enableStamp))
        
        self.doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(desenableStamp))
        
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        
        let date = Date()
        let formater = DateFormatter()
        
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
                
                let stampView = StampView()
                
                stampView.center = position
                stampView.setLabelTexts(city: self.city, country: self.country, date: self.stringDate!)
                
                self.view.addSubview(stampView)
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
    
    @objc func enableStamp(){
        self.startLocationManager()
        self.enableStampBool = !self.enableStampBool
        self.navigationItem.rightBarButtonItem = self.doneButtonItem

    }
    
    @objc func desenableStamp(){
        self.stopLocationManager()
        self.enableStampBool = !self.enableStampBool
        self.navigationItem.rightBarButtonItem = self.addButtonItem

    }
    
}
