//
//  EventoDetalleViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 20/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit

class EventoDetalleViewController: UIViewController {

    var Evento = EventoClass()
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    
    @IBOutlet weak var imagenEvento: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblNombre.text = Evento.Nombre
        lblFecha.text = Evento.Fecha
        lblDescripcion.text =  Evento.Descripcion
        imagenEvento.image = UIImage(data: Evento.Imagen)
        
        
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
