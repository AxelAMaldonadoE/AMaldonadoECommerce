//
//  CarritoController.swift
//  AMaldonadoECommerceVenta
//
//  Created by MacBookMBA15 on 26/05/23.
//

import UIKit

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
        }
        self.tableView.reloadData()
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
            celda.lblCantidad.text = "Cantidad: \(carrito[indexPath.row].Cantidad!)"
            celda.lblNombre.text = "Nombre: \(carrito[indexPath.row].Producto!.Nombre!)"
            if carrito[indexPath.row].Producto?.Imagen! != "" {
                celda.ivProducto.image = convertToUIImage(strBase64: carrito[indexPath.row].Producto!.Imagen!)
            } else {
                celda.ivProducto.image = UIImage(named: "DefaultProducto")
            }
            celda.lblPrecio.text = "Precio: $ \(carrito[indexPath.row].Producto!.PrecioUnitario!)"
            
            return celda
        }
        
        return UITableViewCell()
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
