//
//  StampView.swift
//  Stamp
//
//  Created by Rafael Sol Santos Martins on 09/08/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import Foundation
import UIKit

class StampView : UIView {
    
//    Dados a serem escritos no carimbo, em uma label. São dados default caso não consiga recuperar algum deles.
    var location : String = "Somewhere"
    var date = "01/01/2001"
    var name = "BATMAN"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    fileprivate var contentView : UIView?
    
    fileprivate func loadViewFromXib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = xib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override func draw(_ rect: CGRect) {
        
        let context:CGContext! = UIGraphicsGetCurrentContext()
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        
        // Modifica a área de desenho do contexto atual deixando desenhável
        // apenas a área definida pelo path
        path.addClip()
        
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.black.cgColor
        
        context.saveGState()
        
        context.setShouldAntialias(true)
        
    }
    
    
}
