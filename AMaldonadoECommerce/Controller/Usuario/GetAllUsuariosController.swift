//
//  GetAllUsuariosController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 03/05/23.
//

import UIKit
import SwipeCellKit

class GetAllUsuariosController: UITableViewController {

    var usuarios: [Usuario] = []
    
    var IdUsuario: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateData()
    
        self.registerTableViewCell()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usuarios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if let usuarioCell = tableView.dequeueReusableCell(withIdentifier: "UsuarioCell", for: indexPath) as? UsuarioCell {
            usuarioCell.delegate = self
            usuarioCell.txtNombre.text = usuarios[indexPath.row].Nombre
            usuarioCell.txtApellidoPaterno.text = usuarios[indexPath.row].ApellidoPaterno
            usuarioCell.txtFechaNacimiento.text = usuarios[indexPath.row].FechaNacimiento
            usuarioCell.txtRolNombre.text = usuarios[indexPath.row].Rol?.Nombre
            
            return usuarioCell
        }

        return UITableViewCell()
    }
    

    private func registerTableViewCell() {
        let textFieldCell = UINib(nibName: "UsuarioCell", bundle: nil)
        
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "UsuarioCell")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Lista de Usuarios"
    }

    @IBAction func unwindToGetAll(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        UpdateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateData()
        IdUsuario = 0
        self.tableView.reloadData()
    }
}

extension GetAllUsuariosController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        if orientation == .left {
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                print("Debo ir al formulario!!")
                self.IdUsuario = self.usuarios[indexPath.row].Id!
                self.performSegue(withIdentifier: "Formulario", sender: self)
                self.UpdateData()
            }
            
            updateAction.backgroundColor = UIColor.systemBlue
            return [updateAction]
        } else {
            let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { action, indexPath in
                print("Debo eliminar la celda")
                let result = UsuarioViewModel.Delete(idUsuario: self.usuarios[indexPath.row].Id!)
                if result.Correct! {
                    let alert = UIAlertController(title: "Notificacion", message: "El usuario se elimino correctamente", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                        print("Me regreso a la lista!!")
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    print("Se elimino la informacion del alumno correctamente!")
                    self.UpdateData()
                    self.tableView.reloadData()
                } else {
                    print("No se pudo eliminar la informacion del usuario")
                    let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                        print("Me regreso a la lista!!")
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            deleteAction.image = UIImage(named: "system.delete")
            return [deleteAction]
        }
//        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        return options
    }
    
    func UpdateData() {

        let result = UsuarioViewModel.GetAll()
        usuarios.removeAll()
        if result.Correct! {
            for objUsuario in result.Objects! {
                let usuario = objUsuario as! Usuario
                usuarios.append(usuario)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segue = segue.destination as! UsuarioController
        segue.IdUsuario = self.IdUsuario
    }
}
