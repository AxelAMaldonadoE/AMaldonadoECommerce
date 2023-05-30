//
//  CarritoController.swift
//  AMaldonadoECommerceVenta
//
//  Created by MacBookMBA15 on 26/05/23.
//

import UIKit
import SwipeCellKit

class CarritoController: UITableViewController {
    
    // Variables
    let carritoViewModel = CarritoViewModel()
    var carrito: [Carrito] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCelda()
        UpdateData()
    }
    
    func UpdateData() {
        let result = carritoViewModel.GetAll()
        if result.Correct! {
            // Llenar la informacion del carrito
            carrito.removeAll()
            for objVen in result.Objects! {
                let venta = objVen as! Carrito
                carrito.append(venta)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UpdateData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return carrito.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Productos en el carrito"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let celda = tableView.dequeueReusableCell(withIdentifier: "CarritoCell", for: indexPath) as? CarritoCell {
            celda.delegate = self
            celda.lblCantidad.text = "Cantidad: \(carrito[indexPath.row].Cantidad!)"
            celda.lblNombre.text = "Nombre: \(carrito[indexPath.row].Producto!.Nombre!)"
            if carrito[indexPath.row].Producto?.Imagen! != "" {
                celda.ivProducto.image = convertToUIImage(strBase64: carrito[indexPath.row].Producto!.Imagen!)
            } else {
                celda.ivProducto.image = UIImage(named: "DefaultProducto")
            }
            celda.lblPrecio.text = "Precio: $ \(carrito[indexPath.row].Producto!.PrecioUnitario!)"
            celda.stpCantidad.tag = indexPath.row
            celda.stpCantidad.addTarget(self, action: #selector(ActualizarCantidad), for: .touchUpInside)
            celda.stpCantidad.value = Double(carrito[indexPath.row].Cantidad!)
            let subtotal = carrito[indexPath.row].Producto!.PrecioUnitario! * Float(celda.stpCantidad.value)
            celda.lblSubtotal.text = String(format: "Subtotal: $ %.2f", subtotal)
            
            return celda
        }
        
        return UITableViewCell()
    }
    
    @objc func ActualizarCantidad(sender: UIStepper) {
        print("Se ejecuto la funcion del Stepper en el producto \(carrito[sender.tag].Producto!.Nombre!), \nLa cantidad es \(sender.value)")
        
        if sender.value > 0 {
            let result = carritoViewModel.UpdateCantidad(idProducto: carrito[sender.tag].Producto!.Id!, cantidad: Int(sender.value))
            
            if result.Correct! {
                UpdateData()
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Notificacion", message: "Ocurrio un error \(result.ErrorMessage!)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Notifiacion", message: "¿Deseas eliminar el producto?", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default) {_ in
                let result = self.carritoViewModel.Delete(idProducto: self.carrito[sender.tag].Producto!.Id!)
                
                if result.Correct! {
                    self.UpdateData()
                    self.tableView.reloadData()
                } else {
                    let notificacion = UIAlertController(title: "Notifiacion", message: "No se pudo eliminar el producto!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    
                    notificacion.addAction(action)
                    self.present(notificacion, animated: true)
                }
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .default) {_ in
                sender.value = 1
            }
            
            alert.addAction(aceptar)
            alert.addAction(cancelar)
            
            self.present(alert, animated: true)
        }
            
    }
    
    private func convertToUIImage(strBase64: String) -> UIImage {
        let dataEncoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataEncoded)!
        
        return decodedImage
    }
    
    private func registerCelda() {
        let celda = UINib(nibName: "CarritoCell", bundle: nil)
        
        self.tableView.register(celda, forCellReuseIdentifier: "CarritoCell")
    }
}

extension CarritoController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            let deleteAction = SwipeAction(style: .default, title: "Eliminar") { action, indexPath in
//                let result
                print("Eliminar el registro de \(self.carrito[indexPath.row].Producto!.Nombre!) con un precio de \(self.carrito[indexPath.row].Producto!.PrecioUnitario!)")
                let result = self.carritoViewModel.Delete(idProducto: self.carrito[indexPath.row].Producto!.Id!)
                if result.Correct! {
                    self.UpdateData()
                    let alert = UIAlertController(title: "Notificacion", message: "El producto se elimino correctamente", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Notificacion", message: "Ocurrio un error: \n\(result.ErrorMessage!)",preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            deleteAction.backgroundColor = UIColor.systemRed
            return[deleteAction]
        }
        return []
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        return options
    }
}
