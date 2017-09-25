//
//  entidades.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 09/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import Foundation


class RutaClass{
    
    var Nombre : String
    var Descripcion : String
    var Imagen : Data
    
    init(_Nombre : String, _Descripcion : String, _Imagen : Data ){
        self.Nombre = _Nombre
        self.Descripcion = _Descripcion
        self.Imagen = _Imagen
    }
    
    init(){
        self.Nombre = ""
        self.Descripcion = ""
        self.Imagen = Data()
    }
}

class PuntoClass {
    var Longitud : Double
    var Latitud : Double
    var Nombre : String
    var Imagen : Data
    
    init(_Longitud : Double, _Latitud : Double, _Nombre : String, Imagen : Data) {
        self.Imagen = Imagen
        self.Latitud = _Latitud
        self.Longitud = _Longitud
        self.Nombre = _Nombre
    }
    
    init() {
        self.Imagen = Data()
        self.Latitud = 0.0
        self.Longitud = 0.0
        self.Nombre = ""
    }
    
   /* required init(coder decoder: NSCoder) {
        self.Nombre = decoder.decodeObject(forKey: "Nombre") as? String ?? ""
        self.Latitud = decoder.decodeDouble(forKey: "Latitud") as? Double ?? 0.0
        self.Longitud = decoder.decodeDouble(forKey: "Longitud") as? Double ?? 0.0
        self.Imagen = decoder.decodeData() as? Data ?? Data()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(Nombre, forKey: "Nombre")
        coder.encode(Latitud, forKey: "Latitud")
        coder.encode(Longitud, forKey: "Longitud")
        //coder.encode(Imagen)
    }*/
}




class EventoClass{
    var Nombre : String
    var Descripcion : String
    var Fecha : String
    var Imagen : Data
    
    init(_Nombre : String, _Descripcion : String, _Fecha : String, _Imagen : Data) {
        self.Nombre = _Nombre
        self.Descripcion = _Descripcion
        self.Fecha = _Fecha
        self.Imagen = _Imagen
    }
    
    init() {
        self.Nombre = ""
        self.Descripcion = ""
        self.Fecha = ""
        self.Imagen = Data()
    }

}

class EventoListClass{
    
    var Lista : Array<EventoClass>
    var Succes : Bool
    init() {
        self.Succes = false
        self.Lista = Array<EventoClass>()
    }
    
}
