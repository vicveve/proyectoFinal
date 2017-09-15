//
//  PuntoCreateViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 09/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PuntoCreateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var btnCamara: UIButton!
    @IBOutlet weak var btnAlbum: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    
    private let miPicker = UIImagePickerController()
    var rutaAsiganda = RutaClass(_Nombre: "", _Descripcion: "", _Imagen: Data())
    var contexto : NSManagedObjectContext? = nil
    var contextoPunto : NSManagedObjectContext? = nil
    var puntoCoor = CLLocationCoordinate2D()
    var lstPuntosRuta = Array<PuntoClass>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.contextoPunto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            btnCamara.isHidden = true
        }
        miPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func fnCamara(_ sender: Any) {
        miPicker.sourceType = UIImagePickerControllerSourceType.camera
        
        present(miPicker, animated: true, completion: nil)
    }
    
    @IBAction func fnAlbum(_ sender: Any) {
        miPicker.allowsEditing = false
        miPicker.sourceType = .photoLibrary
        present(miPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        img.contentMode = .scaleAspectFit //3
        img.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func fnGuardar(_ sender: Any) {
        let bExisteError = Valida()
        
        if !bExisteError {
            return
        }
        
        
        UIImageWriteToSavedPhotosAlbum(img.image!, nil, nil, nil)
        
        ///////RUTA/////////
        var rutaManager : NSManagedObject? = nil
        let rutaEntidad = NSEntityDescription.entity(forEntityName: "Ruta", in: self.contexto!)
        
        let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "pcRuta", substitutionVariables: ["nombre": rutaAsiganda.Nombre])
        
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
                    let itemPreCargado = PuntoClass(_Longitud: pLongitud as! Double, _Latitud: pLatitud as! Double, _Nombre: pNombre as! String, Imagen: pImagen as! Data)
                    
                    lstPuntosRuta.append(itemPreCargado)
                }
            }
            
            
        }catch{
            
        }
        
        
        /////RUTA///////////
        
        
        
        
        let puntoEntidad = NSEntityDescription.entity(forEntityName: "Punto", in: self.contextoPunto!)
        
        let peticionp = puntoEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "pcPunto", substitutionVariables: ["nombre": txtNombre.text])
        
        do{
            
            let fetchRequestp : NSFetchRequest<NSFetchRequestResult> = peticionp!
            
            let puntoconsulta = try contextoPunto?.fetch(fetchRequestp) //self.contexto?.fetch(peticion as! NSFetchRequest<NSFetchRequestResult>) //as! [NSObject]
            
            if ((puntoconsulta?.count)! > 0){
                alertaMensaje(mensaje: "La ruta ya se agrego con anterioridad", titulo: "Información")
                
                return
            }
        }catch{
            
        }
        
        //(item as AnyObject).value(forKey: "imagen") as! Data

        var data : Data? = nil
        if img != nil{
            
            if self.img.image != nil{
                data = (UIImagePNGRepresentation(img.image!) as NSData?)! as Data
                
            }
            
        }

        
        let nuevo = PuntoClass(_Longitud: puntoCoor.longitude, _Latitud: puntoCoor.latitude, _Nombre: txtNombre.text!, Imagen: data!)
        
        lstPuntosRuta.append(nuevo)
        
        let datosPunto = creaPuntoEntidad(lst: lstPuntosRuta)
        
        //puntoEntidadNueva.setValue(datosPunto, forKey: "rutaPunto")
        
        rutaManager?.setValue(datosPunto, forKey: "rutaPunto")

        
        
        
        
        do{
            try rutaManager?.managedObjectContext?.save() //self.contexto?.save()
        }catch{
            
        }
        
        let alerta = UIAlertController(title: "Listo", message: "Punto creado", preferredStyle: .alert)
        
        let acctionOk = UIAlertAction(title: "Ok", style: .default, handler: { ACTION in })
        
        alerta.addAction(acctionOk)
        
        var puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        var puntoItem : MKMapItem!
        puntoItem = MKMapItem(placemark: puntoLugar)
        puntoItem.name = txtNombre.text!
        
        
       /* (viewController as? MapaViewController)?.anotaPunto(punto: puntoItem)
        (viewController as? MapaViewController)?.obtenerRutaPunta(destino: puntoItem)
*/
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        
    }
    
    func creaPuntoEntidad(lst : Array<PuntoClass>) -> Set<NSObject>{
        var punto = Set<NSObject>()
        
        
        for i in lst{
            let puntoEntidadNueva = NSEntityDescription.insertNewObject(forEntityName: "Punto", into: self.contexto!)
            
            puntoEntidadNueva.setValue(i.Nombre, forKey: "nombre")
            puntoEntidadNueva.setValue(i.Latitud, forKey: "latitud")
            puntoEntidadNueva.setValue(i.Longitud, forKey: "longitud")
            puntoEntidadNueva.setValue(i.Imagen, forKey: "imagen")
            
            punto.insert(puntoEntidadNueva)

            
        }

        return punto
        
    }

    
    func Valida() -> Bool {
        var bError : Bool = true
        var sError : String = ""
        
        if txtNombre.text == "" {
            bError = false
            sError = "Debe asiganar un nombre a la ruta"
            alertaMensaje(mensaje: sError, titulo: "Alerta")
        }
        if img.image == nil{
            bError = false
            sError = "Debe seleccionar una imagen"
            alertaMensaje(mensaje: sError, titulo: "Alerta")
        }
        
       return bError
    }
    
    func alertaMensaje(mensaje : String, titulo: String){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    
   /* // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let origen = sender as! ViewController
        let destino = segue.destination as! PuntoCreateViewController
        
        destino.rutaAsiganda = rutaA
    }*/
    
  
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
           }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtNombre.resignFirstResponder()
        
    }

    

}
