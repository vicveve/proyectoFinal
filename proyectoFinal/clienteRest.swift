//
//  clienteRest.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 23/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import Foundation
import SystemConfiguration

class RestCliente {
    
    init() {
        
    }
    
    func buscarEventosArchivo() -> EventoListClass {
        let response : EventoListClass = EventoListClass()
        var json : [[String:String]] = []
        do {
            if let file = Bundle.main.path(forResource: "eventos", ofType: "json", inDirectory: "") {
                let data = try Data(contentsOf: URL(fileURLWithPath: file))
                json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [[String : String]]
                
            } else {
                print("No file")
            }
        } catch {
            print(error)
        }
        
        //var uno = son[indexPath.row]["nombre"]
        
        for x in json{
            let item : EventoClass = EventoClass()
            item.Nombre = x["Nombre"]!
            item.Descripcion = x["Descripcion"]!
            item.Fecha = x["Fecha"]!
            let data : NSData = NSData(base64Encoded: x["Imagen"]!, options: .ignoreUnknownCharacters)!
            //var tmpImg =
            item.Imagen = data as Data
            
            response.Lista.append(item)
        }
        
        return response
    }
    
    
   /* func buscarEventos() -> EventoListClass {
        let response : EventoListClass = EventoListClass()
        
        
        let json = sincrono()
        let jsonSring = sincronoString()
        
        let Niv1 = json as! NSDictionary
        let Niv2 = Niv1["lstEventos"] as! NSDictionary
        
        let NivTitulo = Niv2["title"] as! NSString
      response.AgregaTitulo(titulo: NivTitulo as String)
        let NivAutores = Niv2["authors"] as! NSArray
        
        for autor in NivAutores{
            let itemLista = autor as! NSDictionary
            //let url = itemLista["url"] as! NSString
            let autor = itemLista["name"] as! NSString
            response.AgregaAutores(autor: autor as String)
        }
        
        //let llaves = Niv2.allValues
        let llavesCover = Niv2.value(forKey: "cover")
        
        if (llavesCover != nil)
        {
            
            let NivPortada = Niv2["cover"] as! NSDictionary
            let NivPSmall = NivPortada["small"] as! NSString
            let NivPMedium = NivPortada["medium"] as! NSString
            let NivPLarge = NivPortada["large"] as! NSString
            if(NivPSmall as String != "")
            {
                response.AgregaPortadaList(portada: NivPSmall as String)
            }
            if(NivPMedium as String != "")
            {
                response.AgregaPortadaList(portada: NivPMedium as String)
            }
            if(NivPLarge as String != "")
            {
                response.AgregaPortadaList(portada: NivPLarge as String)
            }
            
        }
        
        response.Succes = true
        response.Isbn = codigo
        return response
    }*/
    
   /* func sincronoString()  -> String {
        
        let urls = "http://techcloud.com.mx/eventos/index.php"

        
       
        
        
        let url = NSURL(string: urls)
        let datos :  NSData? = NSData (contentsOf : url! as URL)
        if (datos==nil)
        {
            return ""
        }
        let texto = NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue )
        
        return texto! as String
        
    }
    var nameArray = [String]()
    func sincrono()  -> Any {
        //let session = URLSession.shared
        let urls = "http://techcloud.com.mx/eventos/index.php"
        
        let url = NSURL(string: urls)
        let datos :  NSData? = NSData (contentsOf : url! as URL)
        if(datos == nil)
        {
            return ""
        }
        var jsonResponse : Any = ""
        
        
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            
        }
        catch _ {
            
        }
        
        return jsonResponse
    }*/
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
}
