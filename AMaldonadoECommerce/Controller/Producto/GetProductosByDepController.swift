//
//  GetProductosByDepController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 24/05/23.
//

import UIKit

class GetProductosByDepController: UIViewController {
    
    // Outlets
    @IBOutlet weak var cvProductos: UICollectionView!    
    
    // Variables
    var Productos: [Producto] = []
    var IdDepartamento: Int = 0
    var strBusqueda: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvProductos.delegate = self
        cvProductos.dataSource = self
        registerCelda()
        
        if IdDepartamento != 0 {
            GetByDepartamento()
        } else if strBusqueda != nil {
            GetByBusqueda()
        }
    }
    
    func GetByDepartamento() {
        let result = ProductoViewModel.GetByDep(idDepartamento: IdDepartamento)
        Productos.removeAll()
        
        if result.Correct!{
            for objProduc in result.Objects! {
                let produc = objProduc as! Producto
                Productos.append(produc)
            }
        }
    }
    
    func GetByBusqueda() {
        let result = ProductoViewModel.GetByBusqueda(strBusqueda: self.strBusqueda!)
        Productos.removeAll()
        
        if result.Correct! {
            if result.Objects?.count != 0 {
                for objProduc in result.Objects! {
                    let produc = objProduc as! Producto
                    Productos.append(produc)
                }
            } else {
                let alert = UIAlertController(title: "Notificacion", message: "No se encontraron coincidencias, intenta de nuevo.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    self.performSegue(withIdentifier: "fromProductoBuscar", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
    
}

extension GetProductosByDepController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductoCollCell", for: indexPath) as? ProductoCollCell {
            
            celda.lblNombre.text = Productos[indexPath.row].Nombre!
            celda.lblDescripcion.text = Productos[indexPath.row].Descripcion!
            celda.lblPrecio.text = "$ \(Productos[indexPath.row].PrecioUnitario!)"
            
            if Productos[indexPath.row].Imagen! != "" {
                celda.ivProducto.image = convertToUIImage(strBase64: Productos[indexPath.row].Imagen!)
            } else {
                celda.ivProducto.image = UIImage(named: "DefaultProducto")
            }
            
            return celda
        }
        
        return UICollectionViewCell()
    }
    
    private func registerCelda() {
        let celda = UINib(nibName: "ProductoCollCell", bundle: nil)
        
        self.cvProductos.register(celda, forCellWithReuseIdentifier: "ProductoCollCell")
    }
    
    private func convertToUIImage(strBase64: String) -> UIImage {
        let dataEncoded: Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        let decodedImage: UIImage = UIImage(data: dataEncoded)!
        
        return decodedImage
    }
}
