//
//  QRViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 06/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var sesion : AVCaptureSession?
    var capa : AVCaptureVideoPreviewLayer?
    var marcoQR : UIView?
    var urls :  String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "QR Principal"
        
      /*  navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Regresar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QRViewController.RegresarVista))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu Inicial", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QRViewController.MenuPrincipal))
       */
        
        let dispositivo = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            let entrada = try AVCaptureDeviceInput(device: dispositivo)
            
            sesion = AVCaptureSession()
            sesion?.addInput(entrada)
            
            let metaDatos = AVCaptureMetadataOutput()
            sesion?.addOutput(metaDatos)
            
            metaDatos.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            metaDatos.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            capa = AVCaptureVideoPreviewLayer(session: sesion!)
            capa?.videoGravity = AVLayerVideoGravityResizeAspectFill
            capa?.frame = view.layer.bounds
            view.layer.addSublayer(capa!)
            marcoQR = UIView()
            marcoQR?.layer.borderWidth = 3
            marcoQR?.layer.borderColor = UIColor.red.cgColor
            view.addSubview(marcoQR!)
            sesion?.startRunning()
            
            
        }
        catch{
            
        }

    }
    
    func RegresarVista(){
       // _ = navigationController?.popViewController(animated: true)
       /* if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }*/
        /*let navc = self.navigationController
        if navc != nil{
            navc?.performSegue(withIdentifier: "otro", sender: self)
        }
        else{
            print("No se pudo crear el segue")
        }*/

    }
    
    func MenuPrincipal(){
        _ = navigationController?.popToRootViewController(animated: true)
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        sesion?.startRunning()
        marcoQR?.frame = CGRect.zero
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        marcoQR?.frame = CGRect.zero
        if (metadataObjects == nil || metadataObjects.count == 0){
            return
        }
        
        let objMetaDato = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if (objMetaDato.type == AVMetadataObjectTypeQRCode){
            let objBorde = capa?.transformedMetadataObject(for: objMetaDato as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            marcoQR?.frame = objBorde.bounds
            if(objMetaDato.stringValue != nil){
                self.urls = objMetaDato.stringValue
                
           
               /* sesion?.stopRunning()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LecturaQR") as! LecturaQRViewController
                nextViewController.urls = urls
                self.present(nextViewController, animated:true, completion:nil)
                */
               let navc = self.navigationController
                if navc != nil{
                    navc?.performSegue(withIdentifier: "detalleURL", sender: self)
                }
                else{
                    print("No se pudo crear el segue")
                }
 
                
            }
            
        }
        
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
    @IBAction func Regresa(_ sender: Any) {
        
        //unWindPrevio
        
        self.performSegue(withIdentifier: "unWindPrevio", sender: nil)
        
    }

}
