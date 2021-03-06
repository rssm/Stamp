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

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("StampView", owner: self, options: nil)
        addSubview(contentView)
        self.contentView.backgroundColor = UIColor.clear
        contentView.frame = CGRect(x: -96, y: -36, width: 192, height: 72)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
        
    }
    
//    recebe os dados a serem preenchidos nas labels
    func setData(data : StampData){
        self.cityLabel.text = data.city
        self.dataLabel.text = data.date
        self.countryLabel.text = data.country
        self.center = CGPoint(x: data.centerX!, y: data.centerY!)
    }
}
