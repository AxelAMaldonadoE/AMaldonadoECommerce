//
//  GetAllProductosController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 16/05/23.
//

import UIKit
import SwipeCellKit

class GetAllProductosController: UITableViewController {
    
    var productos: [Producto] = []
    var IdProducto: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateData()
        self.regisertTableViewCell()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let productoCell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as? ProductoCell {
            productoCell.delegate = self
            productoCell.lblNombre.text = productos[indexPath.row].Nombre!
            productoCell.lblPrecio.text = "\( productos[indexPath.row].PrecioUnitario!)"
            productoCell.lblDepartamento.text = productos[indexPath.row].Departamento?.Nombre!
            productoCell.lblDescripcion.text = productos[indexPath.row].Descripcion!
            //productoCell.imagenView?.image = UIImage(named: "DefaultProducto")
            if productos[indexPath.row].Imagen != "" {
                let imagen = convertToUIImage(strBase64: productos[indexPath.row].Imagen!)
                productoCell.imagenView.image = imagen
            } else {
                productoCell.imagenView.image = UIImage(named: "DefaultProducto")
            }
            
            return productoCell
        }
        
        return UITableViewCell()
    }
    
    private func regisertTableViewCell() {
        let textFieldCell = UINib(nibName: "ProductoCell", bundle: nil)
        
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "ProductoCell")
    }
    
    func UpdateData() {
        
        let result = ProductoViewModel.GetAll()
        productos.removeAll()
        if result.Correct! {
            for objProducto in result.Objects! {
                let producto = objProducto as! Producto
                productos.append(producto)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateData()
        IdProducto = 0
        self.tableView.reloadData()
    }
    
    private func convertToUIImage(strBase64: String) -> UIImage {
        let dataEncoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataEncoded)!
        
        return decodedImage
    }
    
    
    @IBAction func unwindToGetAllProductos(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        UpdateData()
    }
}

// MARK: Extension Swipe Cell Kit

extension GetAllProductosController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        if orientation == .left {
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                self.IdProducto = self.productos[indexPath.row].Id!
                self.performSegue(withIdentifier: "FormProducto", sender: self)
//                self.UpdateData()
            }
            
            updateAction.backgroundColor = UIColor.systemBlue
            return [updateAction]
        } else {
            let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { action, indexPath in
                print("Debo eliminar la celda")
                let result = ProductoViewModel.Delete(idProducto: self.productos[indexPath.row].Id!)
                if result.Correct! {
                    let alert = UIAlertController(title: "Notificacion", message: "El producto se elimino correctamente", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default) {(action) -> Void in
                        self.UpdateData()
                        self.tableView.reloadData()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            deleteAction.image = UIImage(systemName: "system.delete")
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
        let segue = segue.destination as! ProductoController
        segue.IdProducto = self.IdProducto
    }
}
