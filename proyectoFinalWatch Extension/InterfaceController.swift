//
//  InterfaceController.swift
//  proyectoFinalWatch Extension
//
//  Created by Victor Ernesto Velasco Esquivel on 21/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var mapa: WKInterfaceMap!
    var sessionWc: WCSession?
    var pInicioZoom = CLLocationCoordinate2D()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
      
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            sessionWc = WCSession.default()
            sessionWc?.delegate = self
            sessionWc?.activate()
        }

        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func zoom(_ value: Float) {
        
        let grados : CLLocationDegrees = CLLocationDegrees(value)/10
        
        let ventana  = MKCoordinateSpanMake(grados, grados)
        
        
        let region = MKCoordinateRegion(center: pInicioZoom, span: ventana)
        self.mapa.setRegion(region)
        self.mapa.addAnnotation(pInicioZoom, with: .red)
        
    }
    
    /*Watch*/
   /* func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }*/
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {


    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data){
 
        self.mapa.removeAllAnnotations()
        
        var lstPuntos = NSKeyedUnarchiver.unarchiveObject(with: messageData) as! [NSDictionary]
        let total = lstPuntos.count
        if total > 0{
            
            let ultimoPunto = lstPuntos[total - 1]
            
            let pInicio = CLLocationCoordinate2D(latitude: ultimoPunto.value(forKey: "Latitud") as! CLLocationDegrees , longitude: ultimoPunto.value(forKey: "Longitud") as! CLLocationDegrees)
            let region = MKCoordinateRegion(center: pInicio, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapa.setRegion(region)
            self.mapa.addAnnotation(pInicio, with: .red)
            self.pInicioZoom = pInicio
            var iContador : Int = 0
            
            for i in lstPuntos{
                iContador += 1
                
                if iContador == total - 1{
                    
                }
                else{
                    let pSiguiente = CLLocationCoordinate2D(latitude: i.value(forKey: "Latitud") as! CLLocationDegrees , longitude: i.value(forKey: "Longitud") as! CLLocationDegrees)
                    self.mapa.addAnnotation(pSiguiente, with: .red)
                }
                
                
            }
            
        }
        
        //sessionWc?.finalize()
        
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
       /* var sPuntos = message["message"]
        var otro = sPuntos
        let ob = try? JSONSerialization.jsonObject(with: <#T##Data#>, options: <#T##JSONSerialization.ReadingOptions#>)
        let total = lstPuntos.count
        if total > 0{
            
            let ultimoPunto = lstPuntos[total - 1]
            
            let pInicio = CLLocationCoordinate2D(latitude: ultimoPunto.Latitud , longitude: ultimoPunto.Longitud)
            let region = MKCoordinateRegion(center: pInicio, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            self.mapa.setRegion(region)
            self.mapa.addAnnotation(pInicio, with: .red)
            
            var iContador : Int = 0
            
            for i in lstPuntos{
                iContador += 1
                
                if iContador == total - 1{
                    
                }
                else{
                    let pSiguiente = CLLocationCoordinate2D(latitude: i.Latitud , longitude: i.Longitud)
                    self.mapa.addAnnotation(pSiguiente, with: .red)
                }
                
                
            }
            
        }*/

        
    }
    
    
    /*Watch*/

    

}
