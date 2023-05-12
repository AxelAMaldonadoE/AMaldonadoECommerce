//
//  GetAllRolesController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 09/05/23.
//

import UIKit
import SwipeCellKit

class GetAllRolesController: UIViewController {
    
    
    @IBOutlet weak var tbvRoles: UITableView!
    var roles: [Rol] = []
    
    var IdRol: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateData()
        
        self.registerTableViewCell()
        
        tbvRoles.delegate = self
        tbvRoles.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateData()
        IdRol = 0
        self.tbvRoles.reloadData()
    }
    
    private func UpdateData() {
        let result = RolViewModel.GetAll()
        roles.removeAll()
        if result.Correct! {
            for objRol in result.Objects! {
                let rol = objRol as! Rol
                roles.append(rol)
            }
        }
    }
    
    @IBAction func unwindToGetAllRoles(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}

// MARK: Extension de UITableView
extension GetAllRolesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rolCell = tableView.dequeueReusableCell(withIdentifier: "RolCell", for: indexPath) as? RolCell {
            rolCell.delegate = self
            rolCell.lblNombre.text = roles[indexPath.row].Nombre
            
            return rolCell
        }
        return UITableViewCell()
    }
    
    private func registerTableViewCell() {
        let textFieldCell = UINib(nibName: "RolCell", bundle: nil)
        
        self.tbvRoles.register(textFieldCell, forCellReuseIdentifier: "RolCell")
    }
}


// MARK: Extension de Swipe Cell Kit
extension GetAllRolesController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                self.IdRol = self.roles[indexPath.row].Id!
                self.performSegue(withIdentifier: "FormRol", sender: self)
            }

            updateAction.backgroundColor = UIColor.systemBlue
            return [updateAction]
        } else {
            let deleteAction = SwipeAction(style: .default, title: "Eliminar") { action, indexPath in
                let result = RolViewModel.Delete(idRol: self.roles[indexPath.row].Id!)
                if result.Correct! {
                    self.UpdateData()
                    self.tbvRoles.reloadData()
                    let alert = UIAlertController(title: "Notificacion", message: "El rol se elimino correctamente", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            deleteAction.backgroundColor = UIColor.systemRed
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        return options
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segue = segue.destination as! RolController
        segue.IdRol = self.IdRol
    }
}
