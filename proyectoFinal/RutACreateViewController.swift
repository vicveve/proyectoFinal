//
//  RutACreateViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 09/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import CoreData

class RutACreateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnCamara: UIButton!
    @IBOutlet weak var btnAlbum: UIButton!
    @IBOutlet weak var img: UIImageView!

     private let miPicker = UIImagePickerController()

    var rutaNew = RutaClass(_Nombre: "", _Descripcion: "", _Imagen: Data())

    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var txtDescripcion: UITextField!
    
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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

    @IBOutlet weak var fnGuardar: UIButton!
    
    @IBAction func Guardar(_ sender: Any) {
        
        let bExisteError = Valida()
        
        if !bExisteError {
            return
        }
        
        
        UIImageWriteToSavedPhotosAlbum(img.image!, nil, nil, nil)
        
        
        
        let rutaEntidad = NSEntityDescription.entity(forEntityName: "Ruta", in: self.contexto!)
        
        let peticion = rutaEntidad?.managedObjectModel.fetchRequestFromTemplate(withName: "pcRuta", substitutionVariables: ["nombre": txtNombre.text])
        
        do{
            
            let fetchRequest : NSFetchRequest<NSFetchRequestResult> = peticion!
           
            let rutaconsulta = try contexto?.fetch(fetchRequest) //self.contexto?.fetch(peticion as! NSFetchRequest<NSFetchRequestResult>) //as! [NSObject]
            
            if ((rutaconsulta?.count)! > 0){
                    alertaMensaje(mensaje: "La ruta ya se agrego con anterioridad", titulo: "Información")
               
                return
            }
        }catch{
            
        }
        
        
        let rutaEntidadNueva = NSEntityDescription.insertNewObject(forEntityName: "Ruta", into: self.contexto!)
        
        rutaEntidadNueva.setValue(txtNombre.text!, forKey: "nombre")
        rutaEntidadNueva.setValue(txtDescripcion.text!, forKey: "descripcion")
        
        if img != nil{
            
            if self.img.image != nil{
                let data = UIImagePNGRepresentation(img.image!) as NSData?
                rutaEntidadNueva.setValue(data!, forKey: "imagen")
            }
            
        }
        
        
        
        do{
            try self.contexto?.save()
        }catch{
            
        }
        
        rutaNew.Descripcion = txtDescripcion.text!
        rutaNew.Nombre = txtNombre.text!
        if img != nil{
            
            if self.img.image != nil{
               rutaNew.Imagen = (UIImagePNGRepresentation(img.image!) as Data?)!
            }
            
        }
     
        let alerta = UIAlertController(title: "Listo", message: "Ruta creada", preferredStyle: .alert)
        
        let acctionOk = UIAlertAction(title: "Ok", style: .default, handler: { ACTION in })
        
        alerta.addAction(acctionOk)
        
    }
    
    
    func Valida() -> Bool {
        var bError : Bool = true
        var sError : String = ""
        
        if txtNombre.text == "" {
            bError = false
            sError = "Debe asiganar un nombre a la ruta"
            alertaMensaje(mensaje: sError, titulo: "Alerta")
        }
        
        if txtDescripcion.text == "" {
            bError = false
            sError = "Debe asignar una descripcion a la ruta"
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
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    
        let destino = segue.destination as! MapaViewController
        
        destino.rutaActual = rutaNew
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtNombre.resignFirstResponder()
        txtDescripcion.resignFirstResponder()
    }
    

}
