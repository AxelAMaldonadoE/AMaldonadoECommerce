//
//  ProductoController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 17/05/23.
//

import UIKit
import DropDown

class ProductoController: UIViewController {
    
    // Outlet Text Field
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var txtStock: UITextField!
    @IBOutlet weak var txtPrecio: UITextField!
    @IBOutlet weak var txtProveedor: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtDepartamento: UITextField!
    
    // Outlet Labels
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var lblPrecioUni: UILabel!
    @IBOutlet weak var lblProveedor: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblDepartamento: UILabel!
    
    // Outlet Image View
    @IBOutlet weak var ivProductoOutlet: UIImageView!
    
    // Variable para manejar ImagePicker
    let imagePicker = UIImagePickerController()
    
    // Outlet Button
    @IBOutlet weak var btnActionsOutlet: UIButton!
    
    // Variables para los DropDown
    let ddDepartamento = DropDown()
    let ddProveedor = DropDown()
    let ddArea = DropDown()
    
    // Listas para llenar los DropDown
    var ListaDepartamentos: [Departamento]? = nil
    var ListaProveedores: [Proveedor]? = nil
    var ListaAreas: [Area]? = nil
    
    // Variables para guardar ID's necesarios
    var IdProducto: Int = 0
    var IdProveedor: Int = 0
    var IdDepartamento: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        txtProveedor.delegate = self
//        txtDepartamento.delegate = self
        
        ConfigurarDrowDown()
        imagePicker.delegate = self

        if IdProducto != 0 {
            GetById(idProducto: IdProducto)
            btnActionsOutlet.setTitle("Actualizar", for: .normal)
        } else {
            btnActionsOutlet.setTitle("Agregar", for: .normal)
            btnActionsOutlet.tintColor = UIColor(red: 55/255, green: 146/255, blue: 55/255, alpha: 1.0)
            ivProductoOutlet.image = UIImage(named: "DefaultProducto")
        }
        
        OcultarLabel()
    }
    
    
    @IBAction func txtAction(_ sender: UITextField) {
        var id = sender.accessibilityIdentifier!
        if id == "txtDepartamento" {
            ddDepartamento.show()
        }
        if id == "txtArea" {
            ddArea.show()
        }
        if id == "txtProveedor" {
            ddProveedor.show()
        }
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        
        guard txtNombre.text != "" else {
            txtNombre.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblNombre.isHidden = false
            return
        }
        txtNombre.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblNombre.isHidden = true
        
        guard txtDescripcion.text != "" else {
            txtDescripcion.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblDescripcion.isHidden = false
            return
        }
        txtDescripcion.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblDescripcion.isHidden = true
        
        guard txtStock.text != "" else {
            txtStock.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblStock.isHidden = false
            return
        }
        txtStock.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblStock.isHidden = true

        guard txtPrecio.text != "" else {
            txtPrecio.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblPrecioUni.isHidden = false
            return
        }
        txtPrecio.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblPrecioUni.isHidden = true

        guard txtProveedor.text != "" else {
            txtProveedor.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblProveedor.isHidden = false
            return
        }
        txtProveedor.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblProveedor.isHidden = true
        
//        guard txtArea.text != "" else {
//            txtArea.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
//            lblArea.isHidden = false
//            return
//        }
//        txtArea.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
//        lblArea.isHidden = true

        guard txtDepartamento.text != "" else {
            txtDepartamento.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblDepartamento.isHidden = false
            return
        }
        txtDepartamento.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblDepartamento.isHidden = true
        
        let opcion = sender.titleLabel?.text
        
        let producto = Producto()
        producto.Nombre = txtNombre.text!
        producto.Descripcion = txtDescripcion.text!
        producto.Stock = Int(txtStock.text!)
        producto.PrecioUnitario = Float(txtPrecio.text!)
        if ivProductoOutlet.image!.isEqual(UIImage(named: "DefaultProducto")) {
            producto.Imagen = ""
        } else {
            producto.Imagen = convertToBase64()
        }
        producto.Proveedor = Proveedor()
        producto.Proveedor?.Id = IdProveedor
        
        producto.Departamento = Departamento()
        producto.Departamento?.Id = IdDepartamento
        
        if IdProducto != 0 {
            producto.Id = IdProducto
        }
        
        if opcion == "Agregar" {
            let result = ProductoViewModel.Add(producto: producto)
            if result.Correct! {
                let alert = UIAlertController(title: "Notificacion", message: "El producto se agrego correctamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                    self.performSegue(withIdentifier: "unwindFromProductoForm", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                    self.performSegue(withIdentifier: "unwindFromProductoForm", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            }
        } else if opcion == "Actualizar" {
            let result = ProductoViewModel.Update(producto: producto)
            if result.Correct! {
                let alert = UIAlertController(title: "Notificacion", message: "El producto se actualizo correctamente!!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                    self.performSegue(withIdentifier: "unwindFromProductoForm", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
    
    @IBAction func setImageProducto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true)
    }
    
    func GetById(idProducto: Int) {
        let result = ProductoViewModel.GetById(idProducto: idProducto)
        if result.Correct! {
            let producto = result.Object as! Producto
            txtNombre.text = producto.Nombre!
            txtDescripcion.text = producto.Descripcion!
            txtStock.text = "\(producto.Stock!)"
            txtPrecio.text = "\(producto.PrecioUnitario!)"
            IdProveedor = producto.Proveedor!.Id!
            txtProveedor.text = producto.Proveedor!.Nombre!
            IdDepartamento = producto.Departamento!.Id!
            txtDepartamento.text = producto.Departamento!.Nombre!
            
            if producto.Imagen! != "" {
                let imagen = convertToUIImage(strBase64: producto.Imagen!)
                ivProductoOutlet.image = imagen
            } else {
                ivProductoOutlet.image = UIImage(named: "DefaultProducto")
            }
        } else {
            let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                print("Me regreso a la lista")
                self.performSegue(withIdentifier: "unwindFromProductoForm", sender: self)
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    private func ConfigurarDrowDown() {
//        DepartamentoDrop()
        ProveedorDrop()
        AreaDrop()
    }
    
    private func ProveedorDrop() {
        ddProveedor.anchorView = txtProveedor
        
        let result = ProveedorViewModel.GetAll()
        if result.Correct! {
            ListaProveedores = []
            
            for objProv in result.Objects! {
                let proveedor = objProv as! Proveedor
                ListaProveedores?.append(proveedor)
            }
            
            for obj in ListaProveedores! {
                ddProveedor.dataSource.append(obj.Nombre!)
            }
            
            ddProveedor.selectionAction = {[unowned self] (index: Int, item: String) in
                txtProveedor.text = item
                print("El Id del proveedor es \(ListaProveedores![index].Id!)")
                IdProveedor = ListaProveedores![index].Id!
            }
        }
    }
    
    private func DepartamentoDrop(idArea: Int) {
        ddDepartamento.anchorView = txtDepartamento
        
        let result = DepartamentoViewModel.GetByIdArea(idArea: idArea)
        if result.Correct! {
            ListaDepartamentos = []
            
            for objDep in result.Objects! {
                let departamento = objDep as! Departamento
                ListaDepartamentos?.append(departamento)
            }
            
            for obj in ListaDepartamentos! {
                ddDepartamento.dataSource.append(obj.Nombre!)
            }
            
            ddDepartamento.selectionAction = { [unowned self] (index: Int, item: String) in
                txtDepartamento.text = item
                print("El Id del Departamento es \(ListaDepartamentos![index].Id!)")
                IdDepartamento = ListaDepartamentos![index].Id!
            }
        }
    }
    
    private func AreaDrop() {
        ddArea.anchorView = txtArea
        
        let result = AreaViewModel.GetAll()
        if result.Correct! {
            ListaAreas = []
            
            for objArea in result.Objects! {
                let area = objArea as! Area
                ListaAreas?.append(area)
            }
            
            for obj in ListaAreas! {
                ddArea.dataSource.append(obj.Nombre!)
            }
            
            ddArea.selectionAction = { [unowned self] (index: Int, item: String) in
                txtArea.text = item
                ddDepartamento.dataSource.removeAll()
                ListaDepartamentos?.removeAll()
                print("El Id del Area es \(ListaAreas![index].Id!)")
                let idArea = ListaAreas![index].Id!
                DepartamentoDrop(idArea: idArea)
            }
        }
    }
   
    private func OcultarLabel() {
        lblNombre.isHidden = true
        lblDescripcion.isHidden = true
        lblStock.isHidden = true
        lblPrecioUni.isHidden = true
        lblProveedor.isHidden = true
        lblArea.isHidden = true
        lblDepartamento.isHidden = true
    }
}

// MARK: Usar los protocolos para Image View

extension ProductoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.ivProductoOutlet.image = pickedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func convertToBase64() -> String {
        let imageData: NSData = ivProductoOutlet.image!.jpegData(compressionQuality: 0.75)! as NSData
        let strBase64: String = imageData.base64EncodedString()
        
        return strBase64
    }
    
    func convertToUIImage(strBase64: String) -> UIImage {
        let dataEncoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataEncoded)!
        
        return decodedImage
    }
}

//// MARK: Usar los protocolos de UITextField
//extension ProductoController: UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let id = textField.accessibilityIdentifier!
//        if id == "txtProveedor" {
//            ddProveedor.show()
//        }
//        if id == "txtDepartamento" {
//            ddDepartamento.show()
//        }
//    }
//}
