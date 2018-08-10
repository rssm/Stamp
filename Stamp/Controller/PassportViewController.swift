//
//  PassportViewController.swift
//  Stamp
//
//  Created by Rafael Sol Santos Martins on 10/08/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import UIKit

class PassportViewController: UIViewController {

    @IBOutlet weak var backgroundPageImageView: UIImageView!
    
    var stampViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let position = sender.location(in: self.view)
        
        //adicionar stamp na posição do toque
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
