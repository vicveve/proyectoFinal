//
//  EventosViewController.swift
//  proyectoFinal
//
//  Created by Victor Ernesto Velasco Esquivel on 20/09/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit

class EventosViewController: UITableViewController {

    var lstEventos : Array<EventoClass> = Array<EventoClass>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let r : RestCliente = RestCliente()
        let lst = r.buscarEventosArchivo()
        
        
        /*let EventoUno = EventoClass(_Nombre: "Evento uno", _Descripcion: "Concierto clasico", _Fecha: "20-12-2017 20:30:00", _Imagen: Data())
        
         let EventoDos = EventoClass(_Nombre: "Evento dos", _Descripcion: "Cascanueces", _Fecha: "27-12-2017 20:00:00", _Imagen:  Data())
        */
        for x in lst.Lista{
            lstEventos.append(x)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lstEventos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaEvento", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = lstEventos[indexPath.row].Nombre;
        cell.detailTextLabel?.text = lstEventos[indexPath.row].Descripcion;
        
        if lstEventos[indexPath.row].Imagen.count > 0 {
            cell.imageView?.image = UIImage(data: lstEventos[indexPath.row].Imagen)
        }
        
        
        
        return cell

    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueEvento"{
            let destino = segue.destination as! EventoDetalleViewController
            let item = self.tableView.indexPathForSelectedRow
            destino.Evento = self.lstEventos[(item?.row)!]
        }
    }
 

}
