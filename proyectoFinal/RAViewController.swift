//
//  RAViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 20/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import CoreLocation

class RAViewController: UIViewController , ARDataSource {

    
    var puntoActualUsuario = PuntoClass()
    var lstPuntosRuta = Array<PuntoClass>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        iniciaRAG(puntoActual: puntoActualUsuario)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func iniciaRAG(puntoActual : PuntoClass){
        
        let latitud = puntoActual.Latitud
        let longitud = puntoActual.Longitud
        let delta = 0.05
        let elementos = lstPuntosRuta.count
        
        let puntosInteres = obtenAnotaciones(latitud: latitud, longitud: longitud, delta: delta, numeroDeElementos: elementos)
        
        let arViewController = ARViewController()
        arViewController.dataSource = self
        // Vertical offset by distance
        arViewController.presenter.distanceOffsetMode = .manual
        arViewController.presenter.distanceOffsetMultiplier = 0.1   // Pixels per meter
        arViewController.presenter.distanceOffsetMinThreshold = 500 // Doesn't raise annotations that are nearer than this
        // Filtering for performance
        arViewController.presenter.maxDistance = 3000               // Don't show annotations if they are farther than this
        arViewController.presenter.maxVisibleAnnotations = 100      // Max number of annotations on the screen
        // Stacking
        arViewController.presenter.verticalStackingEnabled = true
        // Location precision
        arViewController.trackingManager.userDistanceFilter = 15
        arViewController.trackingManager.reloadDistanceFilter = 50
        // Ui
        arViewController.uiOptions.closeButtonEnabled = true
        // Debugging
        arViewController.uiOptions.debugLabel = true
        arViewController.uiOptions.debugMap = true
        arViewController.uiOptions.simulatorDebugging = Platform.isSimulator
        arViewController.uiOptions.setUserLocationToCenterOfAnnotations =  Platform.isSimulator
        // Interface orientation
        arViewController.interfaceOrientationMask = .all
        // Failure handling
        arViewController.onDidFailToFindLocation =
            {
                [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
                // Show alert and dismiss
        }
        
        // Setting annotations
        arViewController.setAnnotations(puntosInteres)
        // Presenting controller
        self.present(arViewController, animated: true, completion: nil)
    }
    
    private func obtenAnotaciones( latitud: Double, longitud: Double, delta: Double, numeroDeElementos: Int) -> Array<ARAnnotation>{
        
        var anotaciones: [ARAnnotation] = []
        //srand48(3)
        for p in lstPuntosRuta
        {
            
            //anotacion.location =
            //anotacion.title = "Punto de interÃ©s"
            let anotacion = ARAnnotation(identifier: p.Nombre , title: p.Nombre, location: CLLocation(latitude: p.Latitud , longitude: p.Longitud))
                //self.obtenerPosiciones(latitud: p.Latitud, longitud: longitud, delta: delta))
            anotaciones.append(anotacion!)
        }
        return anotaciones
        
    }
    
    
    private func obtenerPosiciones( latitud: Double, longitud: Double, delta: Double )-> CLLocation{
        var lat = latitud
        var lon = longitud
        let latDelta = -(delta/2) + drand48() * delta
        let lonDelta = -(delta/2) + drand48() * delta
        lat = lat + latDelta
        lon = lon + lonDelta
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let vista = TestAnnotationView()
        vista.backgroundColor = UIColor.black
        vista.frame  = CGRect(x: 0, y: 0, width: 150, height: 60)
        return vista
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
