//
//  RoundedButton.swift
//  Stamp
//
//  Created by Carlos Marcelo Tonisso Junior on 8/12/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        tintColor = #colorLiteral(red: 0.6197639628, green: 0.6197639628, blue: 0.6197639628, alpha: 0.697707573)
        backgroundColor = tintColor
        imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        setTitleColor(.white, for: [])
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? tintColor : .gray
        }
    }
}
