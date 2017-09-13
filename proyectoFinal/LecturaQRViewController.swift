//
//  LecturaQRViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 06/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit

class LecturaQRViewController: UIViewController {

    @IBOutlet weak var urlLectura: UILabel!
    @IBOutlet weak var vistaWeb: UIWebView!
    var urls : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        urlLectura?.text = urls!
        let url = NSURL(string: urls!)
        let peticion = NSURLRequest(url: url! as URL)
        vistaWeb.loadRequest(peticion as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
