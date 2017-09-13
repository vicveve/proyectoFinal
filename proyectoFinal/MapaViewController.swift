//
//  MapaViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 09/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var abrirMenu: UIBarButtonItem!
    @IBOutlet weak var leadingConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var mapa: MKMapView!
  
    private let manejador = CLLocationManager()
    var lstCoordenadas = Array<CLLocationCoordinate2D>()
    var distanciaTotal : Double = 0
    var distanciaPin : Double = 0
    
    var lstPuntos = Array<MKMapItem>()
    
    var menuShowing = false
    var lstPuntosRuta = Array<RutaClass>()
    var rutaActual = RutaClass(_Nombre: "", _Descripcion: "", _Imagen: Data())
    private var puntoItem : MKMapItem!
    var punto = CLLocationCoordinate2D()
    var esNuevo : Bool = false
    var contexto : NSManagedObjectContext? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
         mapa.delegate = self
        
        if esNuevo{
            
        }
        else{
            //busca en BD
            cargaRuta()
        }
        
        
    }
    
    func limpiaMapa(){
        lstPuntosRuta.removeAll()
        let puntosTotales = self.mapa.annotations
        let overlays = mapa.overlays
        mapa.removeOverlays(overlays)
        //mapa.removeAnnotation(puntosTotales as! MKAnnotation)
    }
    
    func cargaRuta()
    {
        var rutaManager : NSManagedObject? = nil
        let rutaEntidad = NSEntityDescription.entity(forEntityName: "Ruta", in: self.contexto!)
        
        let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "pcRuta", substitutionVariables: ["nombre": rutaActual.Nombre])
        
        do{
            
            let fetchRequest : NSFetchRequest<NSFetchRequestResult> = peticion!
            
            let rutaconsulta = try contexto?.fetch(fetchRequest)
            
            for item in rutaconsulta!
            {
                rutaManager = item as? NSManagedObject
                let puntosFetch = rutaManager?.value(forKey: "rutaPunto") as! Set<NSObject>
                for p in puntosFetch{
                    let pItem = p as! NSManagedObject
                    let pNombre = pItem.value(forKey: "nombre")
                    let pLatitud = pItem.value(forKey: "latitud")
                    let pLongitud = pItem.value(forKey: "longitud")
                    let pImagen = pItem.value(forKey: "imagen")
                    var pPunto = CLLocationCoordinate2D()
                    pPunto.latitude = pLatitud as! CLLocationDegrees
                    pPunto.longitude = pLongitud as! CLLocationDegrees
                    
                    var pPLugar = MKPlacemark(coordinate: pPunto, addressDictionary: nil)
                    
                    puntoItem = MKMapItem(placemark: pPLugar)
                    puntoItem.name = pNombre as! String
                    
                    self.anotaPunto(punto: puntoItem!)
                    
                    lstPuntos.append(puntoItem)
                    
                    
                    
                }
            }
            
           obtenerRutaBD()
        }catch{
            
        }

    }
    
    func obtenerRutaBD(){
        
        let totales : Int = lstPuntos.count
        var ciclos  : Int = 0
        if (totales == 0){
            return
        }
        
        for i in lstPuntos{
            
            let origen = i
            ciclos += 1
            let solicitud = MKDirectionsRequest()
            solicitud.source = origen
            
            if ciclos <= totales - 1{
                solicitud.destination = lstPuntos[ciclos]
                solicitud.transportType = .walking
                
                let indicaciobnes = MKDirections(request: solicitud)
                
                indicaciobnes.calculate(completionHandler: {
                    (response: MKDirectionsResponse?,error : Error?) in
                    if error != nil{
                        print("Error al obtener la ruta")
                    }
                    else{
                        self.muestraRuta(respuesta: response!)
                    }
                    
                    
                })


            }
            
            
            
        }
        
        if totales > 0{
            let centro = lstPuntos[0].placemark.coordinate
            let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
            
            mapa.setRegion(region, animated: true)

        }
       
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        punto.latitude = manager.location!.coordinate.latitude
        punto.longitude = manager.location!.coordinate.longitude
        mapa.centerCoordinate = punto
        
        var puntoLugar = MKPlacemark(coordinate: punto, addressDictionary: nil)
        
        puntoItem = MKMapItem(placemark: puntoLugar)
        puntoItem.name = "INICIO"
        
        ///self.anotaPunto(punto: puntoItem!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    
    @IBAction func abreMenu(_ sender: Any) {
        
        if menuShowing{
            leadingConstrain.constant = -160
        } else{
             leadingConstrain.constant = 0
        }
        
       menuShowing = !menuShowing
        
    }
    
    func obtenerRuta(origen: MKMapItem, destino: MKMapItem){
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .walking
        
        let indicaciobnes = MKDirections(request: solicitud)
        
        indicaciobnes.calculate(completionHandler: {
            (response: MKDirectionsResponse?,error : Error?) in
            if error != nil{
                print("Error al obtener la ruta")
            }
            else{
                self.muestraRuta(respuesta: response!)
            }
            
            
        })
    }
    
    func obtenerRutaPunta(destino: MKMapItem){
        
        let totales : Int = lstPuntos.count
        
        if (totales == 0){
            return
        }
        
        let ultimoPunto = lstPuntos[totales - 1]
        
        let solicitud = MKDirectionsRequest()
        solicitud.source = ultimoPunto
        solicitud.destination = destino
        solicitud.transportType = .walking
        
        let indicaciobnes = MKDirections(request: solicitud)
        
        indicaciobnes.calculate(completionHandler: {
            (response: MKDirectionsResponse?,error : Error?) in
            if error != nil{
                print("Error al obtener la ruta")
            }
            else{
                self.muestraRuta(respuesta: response!)
            }
            
            
        })
    }
    
    func muestraRuta(respuesta : MKDirectionsResponse){
        for ruta in respuesta.routes{
            mapa.add(ruta.polyline, level: MKOverlayLevel.aboveRoads)
            for paso in ruta.steps{
                print(paso.instructions)
            }
        }
        
      //  let centro = origen.placemark.coordinate
       // let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        
        //mapa.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blue
        render.lineWidth = 3.0
        return render
    }
    
    func anotaPunto(punto : MKMapItem){
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapa.addAnnotation(anota)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "seguePunto"{
            
            let destino = segue.destination as! PuntoCreateViewController
            destino.puntoCoor = punto
            destino.rutaAsiganda = rutaActual

        }
    
    
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
        limpiaMapa()
        cargaRuta()
        
    }

        
        
   
    

}
