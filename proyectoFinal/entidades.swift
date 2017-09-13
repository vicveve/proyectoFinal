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
}

class PuntoClass{
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
}
